# Home kubernetes cluster
The software I run in my home cluster.

## Repo Index
<!-- Begin apps section -->
<h3>Clusters</h3>
<ul>
  <li><a href="#apps">apps</a></li>
  <li><a href="#flux">flux</a></li>
</ul>

<h3>Apps</h2>

<h4>apps</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="83"></td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/actual/app/helmrelease.yaml">actual</a></td>
    <td rowspan="83"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/apprise/app/helmrelease.yaml">apprise</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/audiobookshelf/app/helmrelease.yaml">audiobookshelf</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/bazarr/app/helmrelease.yaml">bazarr</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/bazarr/exporter/helmrelease.yaml">bazarr-exporter</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/calibre/app/helmrelease.yaml">calibre</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/cert-manager/cert-manager/app/helmrelease.yaml">cert-manager</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/changedetection/app/helmrelease.yaml">changedetection</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/cilium/app/helmrelease.yaml">cilium</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/cloudflared/app/helmrelease.yaml">cloudflared</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/cnpg/app/helmrelease.yaml">cnpg</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/coredns/app/helmrelease.yaml">coredns</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/cross-seed/app/helmrelease.yaml">cross-seed</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/echo-server/app/helmrelease.yaml">echo-server</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/database/emqx/app/helmrelease.yaml">emqx</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/external-dns/cloudflare/helmrelease.yaml">external-dns-cloudflare</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/external-dns/unifi/helmrelease.yaml">external-dns-unifi</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/filebrowser/app/helmrelease.yaml">filebrowser</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/generic-device-plugin/app/helmrelease.yaml">generic-device-plugin</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/grafana/app/helmrelease.yaml">grafana</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/home-assistant/app/helmrelease.yaml">home-assistant</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/homepage/app/helmrelease.yaml">homepage</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/huntarr/app/helmrelease.yaml">huntarr</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/immich/app/server/helmrelease.yaml">immich</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/immich/app/postgresql.yaml">immich-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/immich/app/proxy/helmrelease.yaml">immich-proxy</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/ingress-nginx/external/helmrelease.yaml">ingress-nginx-external</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/intel-device-plugin/gpu/helmrelease.yaml">intel-device-plugin-gpu</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/intel-device-plugin/app/helmrelease.yaml">intel-device-plugin-operator</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/k8s-gateway/app/helmrelease.yaml">k8s-gateway</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/kavita/app/helmrelease.yaml">kavita</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/kube-prometheus-stack/app/helmrelease.yaml">kube-prometheus-stack</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/kubelet-csr-approver/app/helmrelease.yaml">kubelet-csr-approver</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/lidarr/app/helmrelease.yaml">lidarr</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/lidarr/app/postgresql.yaml">lidarr-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/linkwarden/app/helmrelease.yaml">linkwarden</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/linkwarden/app/postgresql.yaml">linkwarden-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/loki/app/helmrelease.yaml">loki</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/storage/longhorn/app/helmrelease.yaml">longhorn</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/maintainerr/app/helmrelease.yaml">maintainerr</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/maloja/app/helmrelease.yaml">maloja</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/mealie/app/helmrelease.yaml">mealie</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/mealie/app/postgresql.yaml">mealie-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/metrics-server/app/helmrelease.yaml">metrics-server</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/multiscrobbler/app/helmrelease.yaml">multi-scrobbler</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/mylar/app/helmrelease.yaml">mylar</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/node-feature-discovery/app/helmrelease.yaml">node-feature-discovery</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/nvidia-device-plugin/app/helmrelease.yaml">nvidia-device-plugin</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/ollama/app/helmrelease.yaml">ollama</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/open-webui/app/helmrelease.yaml">open-webui</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/open-webui/app/postgresql.yaml">open-webui-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/storage/openebs/app/helmrelease.yaml">openebs</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/overseerr/app/helmrelease.yaml">overseerr</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/paperless/app/helmrelease.yaml">paperless</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/paperless/app/postgresql.yaml">paperless-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/plex/app/helmrelease.yaml">plex</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/prometheus-operator-crds/app/helmrelease.yaml">prometheus-operator-crds</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/promtail/app/helmrelease.yaml">promtail</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/prowlarr/app/helmrelease.yaml">prowlarr</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/prowlarr/app/postgresql.yaml">prowlarr-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/prowlarr/exporter/helmrelease.yaml">prowlarr-exporter</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/qbittorrent/app/helmrelease.yaml">qbittorrent</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/qbittorrent/exporter/helmrelease.yaml">qbittorrent-exporter</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/qbittorrent/tools/helmrelease.yaml">qbtools</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/radarr/app/helmrelease.yaml">radarr</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/radarr/app/postgresql.yaml">radarr-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/radarr/exporter/helmrelease.yaml">radarr-exporter</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/readarr/app/helmrelease.yaml">readarr</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/readarr/app/postgresql.yaml">readarr-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/reloader/app/helmrelease.yaml">reloader</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/shinkro/app/helmrelease.yaml">shinkro</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/smartctl-exporter/app/helmrelease.yaml">smartctl-exporter</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/sonarr/app/helmrelease.yaml">sonarr</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/sonarr/app/postgresql.yaml">sonarr-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/sonarr/exporter/helmrelease.yaml">sonarr-exporter</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/spegel/app/helmrelease.yaml">spegel</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/tailing-sidecar-operator/app/helmrelease.yaml">tailing-sidecar-operator</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/tautulli/app/helmrelease.yaml">tautulli</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/unpoller/app/helmrelease.yaml">unpoller</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/vaultwarden/app/helmrelease.yaml">vaultwarden</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/vaultwarden/app/postgresql.yaml">vaultwarden-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/zigbee2mqtt/app/helmrelease.yaml">zigbee2mqtt</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/zigbee2mqtt/exporter/helmrelease.yaml">zigbee2mqtt-exporter</a></td>
  </tr>
  <tr>
    <td>network</td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/ingress-nginx/internal/helmrelease.yaml">ingress-nginx-internal</a></td>
    <td></td>
  </tr>
</table>

<h4>flux</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">flux-system</td>
    <td><code>GitRepository</code></td>
    <td><a href="https://github.com/cloudnative-pg/cloudnative-pg">cloudnative-pg-crds</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>GitRepository</code></td>
    <td><a href="https://github.com/martinjonsson01/cluster">home-kubernetes</a></td>
  </tr>
</table>
<!-- End apps section -->
