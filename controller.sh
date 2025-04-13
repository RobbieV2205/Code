#!/bin/bash
set -e

# Installeer Kubernetes binaries
apt-get install -y kubelet=1.31.3-1.1 kubeadm=1.31.3-1.1 kubectl=1.31.3-1.1
apt-mark hold kubelet kubeadm kubectl

# Initieer de cluster
kubeadm init --pod-network-cidr=10.10.0.0/16 --kubernetes-version 1.31.3 --node-name k8s-control

# Configureer kubectl
export KUBECONFIG=/etc/kubernetes/admin.conf

# Calico installeren
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml -O /tmp/custom-resources.yaml
sed -i 's?192.168.0.0/16?10.10.0.0/16?' /tmp/custom-resources.yaml
kubectl apply -f /tmp/custom-resources.yaml

# Toon join commando
kubeadm token create --print-join-command
