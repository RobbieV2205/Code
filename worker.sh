#!/bin/bash
set -e

# Installeer Kubernetes binaries
apt-get install -y kubelet=1.31.3-1.1 kubeadm=1.31.3-1.1
apt-mark hold kubelet kubeadm

# Plak hieronder het exacte "kubeadm join ..." commando van de control node:
# kubeadm join <ip>:6443 --token ... --discovery-token-ca-cert-hash sha256:...
