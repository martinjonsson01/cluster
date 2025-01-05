#!/bin/sh
kubectl run temp-shell --rm -i --tty --image ubuntu --privileged -- bash -c "apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-client nfs-common; mkdir /mnt/backups;mount -t nfs 192.168.0.162:/volume1/backups /mnt/backups; cd /mnt/backups;$SHELL"
