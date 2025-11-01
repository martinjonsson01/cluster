#!/bin/sh

node=${1}
#nodeName=$(kubectl get node ${node} -o template --template='{{index .metadata.labels "kubernetes.io/hostname"}}')
nodeSelector='"nodeSelector": { "kubernetes.io/hostname": "'${node:?}'" },'
podName=${USER}-nsenter-${node}
kubectl -n kube-system run "${podName:?}" --restart=Never -it --privileged --rm --image overriden --overrides '
{
  "spec": {
    "hostPID": true,
    "hostNetwork": true,
    '"${nodeSelector?}"'
    "tolerations": [{
        "operator": "Exists"
    }],
    "containers": [
      {
        "name": "nsenter",
        "image": "debian:bookworm",
        "command": ["bash", "-c", "apt update; DEBIAN_FRONTEND=noninteractive apt install -y usbutils nut nut-client nut-server; bash"],
        "stdin": true,
        "tty": true,
        "securityContext": {
          "privileged": true
        },
        "volumeMounts": [
          {
            "name": "host-tmp",
            "mountPath": "/host/var"
          }
        ]
      }
    ],
    "volumes": [
      {
        "name": "host-tmp",
        "hostPath": {
          "path": "/var"
        }
      }
    ]
  }
}'
