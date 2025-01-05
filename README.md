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
    <td rowspan="45"></td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/actual/app/helmrelease.yaml">actual</a></td>
    <td rowspan="45"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/akri/app/helmrelease.yaml">akri</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/cert-manager/cert-manager/app/helmrelease.yaml">cert-manager</a></td>
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
    <td><code>Deployment</code></td>
    <td><a href="kubernetes/apps/default/seafile/app/db-deployment.yaml">db</a></td>
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
    <td><a href="kubernetes/apps/observability/grafana/app/helmrelease.yaml">grafana</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/home-assistant/app/helmrelease.yaml">home-assistant</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/default/immich/app/helmrelease.yaml">immich</a></td>
  </tr>
  <tr>
    <td><code>Cluster</code></td>
    <td><a href="kubernetes/apps/default/immich/app/postgresql.yaml">immich-db</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/ingress-nginx/external/helmrelease.yaml">ingress-nginx-external</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/network/k8s-gateway/app/helmrelease.yaml">k8s-gateway</a></td>
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
    <td><a href="kubernetes/apps/observability/loki/app/helmrelease.yaml">loki</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/storage/longhorn/app/helmrelease.yaml">longhorn</a></td>
  </tr>
  <tr>
    <td><code>Deployment</code></td>
    <td><a href="kubernetes/apps/default/seafile/app/memcached-deployment.yaml">memcached</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/kube-system/metrics-server/app/helmrelease.yaml">metrics-server</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/storage/openebs/app/helmrelease.yaml">openebs</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/apps/observability/prometheus-operator-crds/app/helmrelease.yaml">prometheus-operator-crds</a></td>
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
    <td><a href="kubernetes/apps/default/qbittorrent/app/helmrelease.yaml">qbittorrent</a></td>
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
    <td><a href="kubernetes/apps/kube-system/reloader/app/helmrelease.yaml">reloader</a></td>
  </tr>
  <tr>
    <td><code>Deployment</code></td>
    <td><a href="kubernetes/apps/default/seafile/app/seafile-server-deployment.yaml">seafile-server</a></td>
  </tr>
  <tr>
    <td><code>Deployment</code></td>
    <td><a href="kubernetes/apps/default/seafile/app/seahub-deployment.yaml">seahub</a></td>
  </tr>
  <tr>
    <td><code>Deployment</code></td>
    <td><a href="kubernetes/apps/default/seafile/app/seahub-media-deployment.yaml">seahub-media</a></td>
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
    <td><a href="kubernetes/apps/kube-system/spegel/app/helmrelease.yaml">spegel</a></td>
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
