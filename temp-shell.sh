#!/bin/sh
kubectl run temp-shell --rm -i --tty --image ubuntu --privileged -- bash
