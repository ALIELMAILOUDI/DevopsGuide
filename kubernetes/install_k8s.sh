#!/bin/bash
set -e

echo "=== STEP 1: Update and install dependencies ==="
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

echo "=== STEP 2: Add Kubernetes official GPG key ==="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "=== STEP 3: Add Kubernetes APT repository ==="
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "=== STEP 4: Install kubelet, kubeadm, kubectl ==="
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl

echo "=== STEP 5: Hold versions to prevent unintended upgrades ==="
sudo apt-mark hold kubelet kubeadm kubectl

echo "=== Kubernetes installation completed successfully! ==="
kubeadm version && kubectl version --client

