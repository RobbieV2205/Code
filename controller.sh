#!/bin/bash
set -e

# Kernel modules
echo -e "overlay\nbr_netfilter" > /etc/modules-load.d/containerd.conf
modprobe overlay
modprobe br_netfilter

# Netwerk instellingen
cat <<EOF > /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system

# Install containerd
wget https://github.com/containerd/containerd/releases/download/v1.7.24/containerd-1.7.24-linux-amd64.tar.gz -P /tmp/
tar Cxzvf /usr/local /tmp/containerd-1.7.24-linux-amd64.tar.gz
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -P /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now containerd

# Install runc
wget https://github.com/opencontainers/runc/releases/download/v1.2.2/runc.amd64 -P /tmp/
install -m 755 /tmp/runc.amd64 /usr/local/sbin/runc

# Install CNI plugins
wget https://github.com/containernetworking/plugins/releases/download/v1.6.2/cni-plugins-linux-amd64-v1.6.2.tgz -P /tmp/
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin /tmp/cni-plugins-linux-amd64-v1.6.2.tgz

# Genereer config.toml en wijzig SystemdCgroup naar true
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd

# Schakel swap uit
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Kubernetes repo
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gpg
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' > /etc/apt/sources.list.d/kubernetes.list
apt-get update

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
