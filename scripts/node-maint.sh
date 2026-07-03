#!/usr/bin/env bash
#
# node-maint.sh - worker-node physical-maintenance automation (take-down / bring-back)
#
# Usage:
#   scripts/node-maint.sh take-down  <node>   # graceful drain -> force off -> "SAFE TO UNPLUG"
#   scripts/node-maint.sh bring-back <node>   # wait for power-on -> health -> rebalance -> full verify
#   scripts/node-maint.sh full       <node>   # take-down, then bring-back (waits while you clean)
#   scripts/node-maint.sh status     <node>   # read-only summary, always exit 0
#
# Contract (for humans and LLMs driving this script):
#   exit 0  - phase complete (MAINT_PHASE_DONE / MAINT_DONE printed)
#   exit 1  - usage/environment error, or unexpected script failure (MAINT_ERROR)
#   exit 2  - MAINT_BLOCKED: a step's postcondition can't be met. Evidence and a hint
#             are printed. An operator (LLM or human) fixes the cause, then RE-RUNS THE
#             SAME COMMAND: every step first checks whether its postcondition already
#             holds in the cluster, so completed work fast-forwards in seconds.
#
#   LLM intervention rules on MAINT_BLOCKED: bounded, controller-safe actions only
#   (kubectl delete pod of controller-backed pods, waiting longer, restarting a flaky
#   exporter). Never: talosctl force/reset decided autonomously, Longhorn CRD edits,
#   anything involving a `faulted` volume or data/filesystem errors -> ask the human.
#
# Env knobs (defaults tuned from real runs on guts/griffith):
#   DRY_RUN=1              echo mutating commands instead of running; waits don't block
#   REBALANCE_NS           namespace whose movable pods get rebalanced (default: default)
#   REBALANCE_MIN_DIFF     min pod-count gap peer-vs-node before rebalancing (default: 25)
#   DRAIN_TIMEOUT OFF_TIMEOUT POWERON_TIMEOUT READY_TIMEOUT UNCORDON_TIMEOUT
#   CORE_TIMEOUT SETTLE_TIMEOUT PODS_TIMEOUT VOLUMES_TIMEOUT ALERTS_TIMEOUT   (seconds)

set -o errexit
set -o nounset
set -o pipefail

PHASE=${1:-}
NODE=${2:-}

DRY_RUN=${DRY_RUN:-0}
REBALANCE_NS=${REBALANCE_NS:-default}
REBALANCE_MIN_DIFF=${REBALANCE_MIN_DIFF:-25}
DRAIN_TIMEOUT=${DRAIN_TIMEOUT:-360}
OFF_TIMEOUT=${OFF_TIMEOUT:-240}
POWERON_TIMEOUT=${POWERON_TIMEOUT:-3600}
READY_TIMEOUT=${READY_TIMEOUT:-600}
UNCORDON_TIMEOUT=${UNCORDON_TIMEOUT:-300}
CORE_TIMEOUT=${CORE_TIMEOUT:-420}
SETTLE_TIMEOUT=${SETTLE_TIMEOUT:-480}
PODS_TIMEOUT=${PODS_TIMEOUT:-300}
VOLUMES_TIMEOUT=${VOLUMES_TIMEOUT:-3600}
ALERTS_TIMEOUT=${ALERTS_TIMEOUT:-600}

# Pod owner kinds that can never be evicted by a drain; a node is "drained" when
# every remaining pod is one of these. CNPG DB pods are Cluster-owned (hostpath),
# Longhorn managers are PDB-protected, DaemonSets restart in place by design.
UNEVICTABLE_KINDS='["DaemonSet","Cluster","InstanceManager","ShareManager"]'
KNOWN_NOISE_ALERTS='["Watchdog","InfoInhibitor"]'
ALERTMANAGER_PROXY="/api/v1/namespaces/observability/services/kube-prometheus-stack-alertmanager:9093/proxy/api/v2/alerts?active=true"

CURPHASE=$PHASE

log()  { echo "[node-maint $(date +%H:%M:%S)] $*"; }
skip() { log "step=$1 SKIP ($2)"; }

trap 'st=$?; if [ "$st" -eq 1 ]; then echo "MAINT_ERROR unexpected failure near line $LINENO (exit $st)"; fi' ERR

blocked() { # <step> <reason> <hint> [evidence]
    echo "MAINT_BLOCKED node=$NODE phase=$CURPHASE step=$1 reason=\"$2\""
    if [ -n "${4:-}" ]; then
        echo "--- evidence ---"; echo "$4"; echo "--- end evidence ---"
    fi
    echo "MAINT_HINT $3"
    echo "MAINT_RESUME fix the cause, then re-run: $0 $CURPHASE $NODE  (idempotent, fast-forwards)"
    exit 2
}

run_mut() { # mutating command, gated by DRY_RUN
    if [ "$DRY_RUN" = 1 ]; then log "DRY_RUN: $*"; else "$@"; fi
}

# wait_for <timeout-s> <description> <check-fn>; returns 1 on timeout.
# Under DRY_RUN an unmet condition is reported and treated as met.
wait_for() {
    local timeout=$1 desc=$2 fn=$3 t0
    t0=$(date +%s)
    while true; do
        if "$fn"; then return 0; fi
        if [ "$DRY_RUN" = 1 ]; then log "DRY_RUN: would wait for: $desc"; return 0; fi
        if [ $(( $(date +%s) - t0 )) -ge "$timeout" ]; then return 1; fi
        sleep 5
    done
}

node_pings() { ping -c1 -W2 "$IP" >/dev/null 2>&1; }

pings_n_consecutive() { # <up|down> <n> -> 0 once state observed n times in a row
    local want=$1 n=$2 c=0
    while [ "$c" -lt "$n" ]; do
        if node_pings; then [ "$want" = up ] && c=$((c+1)) || c=0
        else                [ "$want" = down ] && c=$((c+1)) || c=0
        fi
        sleep 2
    done
}

pods_on_node() { kubectl get pods -A -o json --field-selector "spec.nodeName=$NODE" 2>/dev/null; }

active_pods_filter='[.items[] | select(.status.phase != "Succeeded" and .status.phase != "Failed")]'

count_remaining() { pods_on_node | jq "$active_pods_filter | length"; }
count_movable() {
    pods_on_node | jq "$active_pods_filter
        | [.[] | select((.metadata.ownerReferences[0].kind // \"none\") as \$k
                        | $UNEVICTABLE_KINDS | index(\$k) | not)] | length"
}
list_movable() {
    pods_on_node | jq -r "$active_pods_filter
        | .[] | select((.metadata.ownerReferences[0].kind // \"none\") as \$k
                       | $UNEVICTABLE_KINDS | index(\$k) | not)
        | \"\(.metadata.namespace)/\(.metadata.name) [\(.metadata.ownerReferences[0].kind // \"-\")] \(.status.phase)\""
}

# Cluster-wide (or -n <ns>) pods that are not Running-and-all-containers-ready.
not_ready_pods() { # [namespace]
    local scope=(-A); [ -n "${1:-}" ] && scope=(-n "$1")
    kubectl get pods "${scope[@]}" -o json | jq -r '
        [.items[] | select(.status.phase != "Succeeded")
         | select(((.status.phase == "Running")
                   and ([.status.containerStatuses[]?.ready] | length > 0 and all)) | not)]
        | .[] | "\(.metadata.namespace)/\(.metadata.name) phase=\(.status.phase) ready=\([.status.containerStatuses[]?.ready] | map(if . then "1" else "0" end) | join(""))"'
}

unhealthy_attached_volumes() {
    kubectl -n storage get volumes.longhorn.io -o json | jq -r '
        [.items[] | select(.status.state == "attached" and .status.robustness != "healthy")]
        | .[] | "\(.metadata.name) state=\(.status.state) robustness=\(.status.robustness)"'
}

real_alerts() { # active alerts minus known always-on noise
    kubectl get --raw "$ALERTMANAGER_PROXY" 2>/dev/null | jq -r "
        [.[] | select(.labels.alertname as \$a | $KNOWN_NOISE_ALERTS | index(\$a) | not)]
        | .[] | \"\(.labels.alertname) severity=\(.labels.severity // \"-\") since=\(.startsAt) \(.labels.pod // .labels.node // .labels.instance // \"\")\""
}

# ---------------------------------------------------------------- take-down --

take_down() {
    CURPHASE=take-down

    # step: preflight ----------------------------------------------------------
    if ! node_pings && [ "$DRY_RUN" != 1 ]; then
        skip preflight "$NODE does not answer ping - already powered off"
        date +%s > "$STATE_DIR/last-takedown"
        log "MAINT_SAFE_TO_UNPLUG node=$NODE"
        return 0
    fi
    local peer_ok
    peer_ok=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' --no-headers \
        | awk -v n="$NODE" '$1 != n && $2 == "Ready" {c++} END {print c+0}')
    [ "$peer_ok" -ge 1 ] \
        || blocked preflight "no other Ready worker to receive evicted pods" \
             "check why the peer worker is not Ready before taking $NODE down" \
             "$(kubectl get nodes)"
    local unhealthy_vols
    unhealthy_vols=$(unhealthy_attached_volumes)
    [ -z "$unhealthy_vols" ] \
        || blocked preflight "Longhorn volumes not fully healthy - taking $NODE down could drop the last good replica" \
             "wait for rebuilds to finish (robustness=healthy), then re-run" \
             "$unhealthy_vols"
    log "step=preflight OK (peer worker Ready, all attached volumes healthy)"

    # step: graceful-shutdown --------------------------------------------------
    if [ "$(kubectl get node "$NODE" -o jsonpath='{.spec.unschedulable}')" = "true" ]; then
        skip graceful-shutdown "$NODE already cordoned - graceful shutdown already issued"
    else
        run_mut talosctl -n "$IP" shutdown --wait=false
        log "step=graceful-shutdown issued (cordon+drain runs node-side)"
    fi

    # step: drain-watch --------------------------------------------------------
    local t0 prev="" total movable
    t0=$(date +%s)
    while true; do
        total=$(count_remaining); movable=$(count_movable)
        if [ "$total$movable" != "$prev" ]; then
            log "step=drain-watch remaining=$total movable=$movable"
            prev="$total$movable"
        fi
        [ "$movable" -eq 0 ] && break
        if [ "$DRY_RUN" = 1 ]; then log "DRY_RUN: would wait for drain (movable=0)"; break; fi
        [ $(( $(date +%s) - t0 )) -ge "$DRAIN_TIMEOUT" ] \
            && blocked drain-watch "drain stalled: $movable evictable pod(s) still on $NODE after ${DRAIN_TIMEOUT}s" \
                 "inspect the listed pods (describe/logs); controller-backed hung pods may be deleted, then re-run. Do NOT force-shutdown around a non-empty movable set without human approval" \
                 "$(list_movable)"
        sleep 5
    done
    log "step=drain-watch OK (only unevictable pods remain)"

    # step: force-off ----------------------------------------------------------
    # Guardrail re-verified on every run: only force when nothing evictable remains.
    movable=$(count_movable)
    [ "$movable" -eq 0 ] || [ "$DRY_RUN" = 1 ] \
        || blocked force-off "guardrail: $movable evictable pod(s) reappeared on $NODE" \
             "re-run to re-enter drain-watch" "$(list_movable)"
    run_mut talosctl -n "$IP" shutdown --force --wait=false
    log "step=force-off issued"

    # step: confirm-off --------------------------------------------------------
    if [ "$DRY_RUN" = 1 ]; then
        log "DRY_RUN: would ping until 3 consecutive misses"
    else
        local off_deadline=$(( $(date +%s) + OFF_TIMEOUT ))
        ( pings_n_consecutive down 3 ) &
        local wpid=$!
        while kill -0 "$wpid" 2>/dev/null; do
            [ "$(date +%s)" -ge "$off_deadline" ] \
                && { kill "$wpid" 2>/dev/null || true; \
                     blocked confirm-off "$NODE still answers ping ${OFF_TIMEOUT}s after force shutdown" \
                       "check node console/talosctl; it may be wedged mid-shutdown" ""; }
            sleep 3
        done
    fi
    if [ "$DRY_RUN" != 1 ]; then
        date +%s > "$STATE_DIR/last-takedown"
        rm -f "$STATE_DIR/rebalance-done"
    fi
    log "step=confirm-off OK ($NODE is dark)"
    log "MAINT_SAFE_TO_UNPLUG node=$NODE"
}

# --------------------------------------------------------------- bring-back --

bring_back() {
    CURPHASE=bring-back

    # step: wait-power-on ------------------------------------------------------
    if node_pings; then
        skip wait-power-on "$NODE already answers ping"
    elif [ "$DRY_RUN" = 1 ]; then
        log "DRY_RUN: would wait for $NODE to answer ping"
    else
        log "step=wait-power-on waiting for $NODE to answer ping (plug it in; timeout ${POWERON_TIMEOUT}s)"
        local on_deadline=$(( $(date +%s) + POWERON_TIMEOUT ))
        ( pings_n_consecutive up 3 ) &
        local wpid=$!
        while kill -0 "$wpid" 2>/dev/null; do
            [ "$(date +%s)" -ge "$on_deadline" ] \
                && { kill "$wpid" 2>/dev/null || true; \
                     blocked wait-power-on "$NODE not pingable after ${POWERON_TIMEOUT}s" \
                       "power it on, then re-run" ""; }
            sleep 3
        done
    fi
    log "step=wait-power-on OK"

    # step: wait-ready ---------------------------------------------------------
    node_ready() { kubectl get node "$NODE" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null | grep -qx True; }
    wait_for "$READY_TIMEOUT" "kubelet Ready" node_ready \
        || blocked wait-ready "$NODE pings but kubelet not Ready after ${READY_TIMEOUT}s" \
             "talosctl -n $IP dmesg / service status; boot may be stuck" \
             "$(kubectl get node "$NODE" -o wide 2>&1 || true)"
    log "step=wait-ready OK"

    # step: wait-uncordon (Talos auto-uncordons ~30s after Ready) --------------
    node_schedulable() { [ -z "$(kubectl get node "$NODE" -o jsonpath='{.spec.unschedulable}' 2>/dev/null)" ]; }
    if ! wait_for "$UNCORDON_TIMEOUT" "auto-uncordon" node_schedulable; then
        log "step=wait-uncordon WARN: auto-uncordon did not happen in ${UNCORDON_TIMEOUT}s - uncordoning manually"
        run_mut kubectl uncordon "$NODE"
        node_schedulable || blocked wait-uncordon "manual uncordon did not stick" "inspect node taints/conditions" \
            "$(kubectl describe node "$NODE" | sed -n '1,25p')"
    fi
    log "step=wait-uncordon OK ($NODE schedulable)"

    # step: talos-health -------------------------------------------------------
    local health_out
    if health_out=$(talosctl -n "$IP" health --server=false --wait-timeout=5m 2>&1); then
        log "step=talos-health OK"
    else
        blocked talos-health "talosctl health failed" "read the failing check in the evidence" "$health_out"
    fi

    # step: core-ready (plumbing the rescheduled pods will need) ---------------
    core_ready() {
        [ "$(kubectl -n storage get nodes.longhorn.io "$NODE" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)" = "True" ] || return 1
        local bad
        bad=$(pods_on_node | jq "[.items[]
            | select(.metadata.namespace == \"kube-system\" or .metadata.namespace == \"storage\")
            | select(.status.phase != \"Succeeded\")
            | select(((.status.phase == \"Running\") and ([.status.containerStatuses[]?.ready] | length > 0 and all)) | not)] | length")
        [ "$bad" -eq 0 ]
    }
    wait_for "$CORE_TIMEOUT" "core plumbing Ready" core_ready \
        || blocked core-ready "kube-system/storage pods on $NODE (or Longhorn node) not Ready after ${CORE_TIMEOUT}s" \
             "describe/logs of the listed pods" \
             "$(not_ready_pods | grep -E "^(kube-system|storage)/" || true)"
    log "step=core-ready OK"

    # step: rebalance (delete movable pods on the overloaded peer; one pass) ---
    local takedown_ts rebal_ts
    takedown_ts=$(cat "$STATE_DIR/last-takedown" 2>/dev/null || echo 0)
    rebal_ts=$(cat "$STATE_DIR/rebalance-done" 2>/dev/null || echo 0)
    if [ "$rebal_ts" -gt "$takedown_ts" ] && [ $(( $(date +%s) - rebal_ts )) -lt 21600 ]; then
        skip rebalance "one pass already done this maintenance session (never overshoot with a second)"
    else
        local peer node_n peer_n
        peer=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' --no-headers -o custom-columns=NAME:.metadata.name | grep -vx "$NODE" | head -1)
        node_n=$(count_remaining)
        peer_n=$(kubectl get pods -A -o json --field-selector "spec.nodeName=$peer" | jq "$active_pods_filter | length")
        log "step=rebalance distribution: $NODE=$node_n $peer=$peer_n"
        if [ $(( peer_n - node_n )) -lt "$REBALANCE_MIN_DIFF" ]; then
            skip rebalance "diff below threshold ($REBALANCE_MIN_DIFF) - balanced enough"
        else
            local victims
            victims=$(kubectl get pods -n "$REBALANCE_NS" -o json --field-selector "spec.nodeName=$peer" \
                | jq -r '.items[] | select(.metadata.ownerReferences[0].kind == "ReplicaSet") | .metadata.name')
            if [ -z "$victims" ]; then
                skip rebalance "no ReplicaSet-owned pods on $peer in ns/$REBALANCE_NS"
            else
                log "step=rebalance deleting $(echo "$victims" | wc -l) movable pods on $peer (ns/$REBALANCE_NS)"
                echo "$victims" | run_mut xargs kubectl delete pod -n "$REBALANCE_NS" --wait=false >/dev/null
            fi
        fi
        [ "$DRY_RUN" = 1 ] || date +%s > "$STATE_DIR/rebalance-done"
    fi

    # step: settle (rebalanced namespace back to fully Ready) ------------------
    ns_settled() { [ -z "$(not_ready_pods "$REBALANCE_NS")" ]; }
    wait_for "$SETTLE_TIMEOUT" "ns/$REBALANCE_NS settled" ns_settled \
        || blocked settle "pods in ns/$REBALANCE_NS not all Ready after ${SETTLE_TIMEOUT}s" \
             "usual suspects: Longhorn Multi-Attach wait, slow fsGroup chown, replica waiting on its master. describe/logs; deleting a stuck controller-backed pod is safe" \
             "$(not_ready_pods "$REBALANCE_NS")"
    log "step=settle OK"

    # step: verify-pods (whole cluster) ----------------------------------------
    all_pods_ok() { [ -z "$(not_ready_pods)" ]; }
    wait_for "$PODS_TIMEOUT" "all pods Ready cluster-wide" all_pods_ok \
        || blocked verify-pods "cluster-wide pods not all Ready after ${PODS_TIMEOUT}s" \
             "triage each listed pod (describe/logs); delete-to-recreate is safe for controller-backed pods; escalate real errors" \
             "$(not_ready_pods)"
    log "step=verify-pods OK"

    # step: verify-storage (Longhorn rebuilds; short outages resync instantly) -
    local t0 prev="" vols faulted
    t0=$(date +%s); prev=""
    while true; do
        vols=$(unhealthy_attached_volumes)
        faulted=$(echo "$vols" | grep -c faulted || true)
        [ "$faulted" -gt 0 ] \
            && blocked verify-storage "FAULTED Longhorn volume(s) - data at risk" \
                 "STOP - do not poke faulted volumes; human intervention required" "$vols"
        [ -z "$vols" ] && break
        if [ "$vols" != "$prev" ]; then
            log "step=verify-storage waiting on rebuilds: $(echo "$vols" | wc -l) volume(s) not healthy"
            prev=$vols
        fi
        if [ "$DRY_RUN" = 1 ]; then log "DRY_RUN: would wait for volume rebuilds"; break; fi
        [ $(( $(date +%s) - t0 )) -ge "$VOLUMES_TIMEOUT" ] \
            && blocked verify-storage "rebuilds still running after ${VOLUMES_TIMEOUT}s" \
                 "large volumes rebuild slowly; check progress in Longhorn UI, re-run to keep waiting" "$vols"
        sleep 20
    done
    log "step=verify-storage OK (all attached volumes healthy)"

    # step: verify-alerts (give transients time to self-clear) -----------------
    kubectl get --raw "$ALERTMANAGER_PROXY" >/dev/null 2>&1 \
        || blocked verify-alerts "cannot reach Alertmanager via API-server proxy" \
             "check the alertmanager pod/svc in ns/observability; without it this verification is blind" ""
    alerts_clear() { [ -z "$(real_alerts)" ]; }
    wait_for "$ALERTS_TIMEOUT" "alerts to clear" alerts_clear \
        || blocked verify-alerts "active alerts beyond known noise after ${ALERTS_TIMEOUT}s" \
             "triage each: new-vs-preexisting, transient-vs-real; cross-check against pod/volume state (correlated layers); known flaky: Zigbee2MqttUnavailable -> delete exporter pod" \
             "$(real_alerts)"
    log "step=verify-alerts OK (only known always-on noise)"

    log "MAINT_PHASE_DONE phase=bring-back node=$NODE"
}

# ------------------------------------------------------------------- status --

status() {
    log "node=$NODE ip=$IP ping=$(node_pings && echo up || echo down)"
    kubectl get node "$NODE" --no-headers 2>/dev/null || echo "  (no node object)"
    log "pods per node:"
    kubectl get pods -A -o json | jq -r '[.items[] | select(.status.phase != "Succeeded" and .status.phase != "Failed") | .spec.nodeName] | group_by(.) | map("  \(.[0]): \(length)") | .[]'
    log "not-Ready pods: $(not_ready_pods | wc -l)"
    not_ready_pods | sed 's/^/  /'
    log "unhealthy attached Longhorn volumes: $(unhealthy_attached_volumes | grep -c . || true)"
    unhealthy_attached_volumes | sed 's/^/  /'
    log "active alerts beyond known noise:"
    real_alerts | sed 's/^/  /'
    local td rb
    td=$(cat "$STATE_DIR/last-takedown" 2>/dev/null || echo -)
    rb=$(cat "$STATE_DIR/rebalance-done" 2>/dev/null || echo -)
    log "state: last-takedown=$td rebalance-done=$rb"
}

# --------------------------------------------------------------------- main --

case "$PHASE" in
    take-down|bring-back|full|status) ;;
    *) echo "usage: $0 <take-down|bring-back|full|status> <node>"; exit 1 ;;
esac
[ -n "$NODE" ] || { echo "usage: $0 <take-down|bring-back|full|status> <node>"; exit 1; }

for bin in kubectl talosctl jq ping; do
    command -v "$bin" >/dev/null || { echo "MAINT_ERROR missing dependency: $bin"; exit 1; }
done

kubectl get node "$NODE" >/dev/null 2>&1 || { echo "MAINT_ERROR node '$NODE' not found in cluster"; exit 1; }
if kubectl get node "$NODE" --show-labels --no-headers | grep -q 'node-role.kubernetes.io/control-plane'; then
    echo "MAINT_ERROR $NODE is a control-plane node - this script only handles workers (quorum risk)"; exit 1
fi
IP=$(kubectl get node "$NODE" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
[ -n "$IP" ] || { echo "MAINT_ERROR could not resolve InternalIP for $NODE"; exit 1; }

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/node-maint/$NODE"
mkdir -p "$STATE_DIR"

log "phase=$PHASE node=$NODE ip=$IP dry_run=$DRY_RUN"

case "$PHASE" in
    take-down)  take_down ;;
    bring-back) bring_back ;;
    full)       take_down; log "--- physical maintenance window: unplug, clean, plug back in ---"; bring_back ;;
    status)     status ;;
esac

if [ "$PHASE" != status ]; then
    log "MAINT_DONE phase=$PHASE node=$NODE"
fi
