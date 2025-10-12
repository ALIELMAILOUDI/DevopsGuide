#!/bin/bash
set -e

echo "=== STEP 0: Reset old cluster and cleanup ==="
sudo kubeadm reset -f
sudo rm -rf /etc/cni/net.d
sudo iptables -F
sudo ipvsadm --clear || true
rm -rf $HOME/.kube

echo "=== STEP 1: Pull Kubernetes images ==="
sudo kubeadm config images pull

echo "=== STEP 2: Initialize Kubernetes cluster ==="
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

echo "=== STEP 3: Setup kubeconfig ==="
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "=== STEP 4: Deploy Flannel CNI ==="
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

echo "Kubernetes cluster initialized successfully!"
