#!/bin/bash
set -e

echo "=== STEP 1: Install prerequisites ==="
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "=== STEP 2: Add Docker’s official GPG key and repository ==="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y

echo "=== STEP 3: Install containerd ==="
sudo apt install -y containerd.io

echo "=== STEP 4: Generate default config and patch it for Kubernetes ==="
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Enable systemd cgroup driver (required by kubeadm)
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

echo "=== STEP 5: Restart and enable containerd service ==="
sudo systemctl daemon-reexec
sudo systemctl restart containerd
sudo systemctl enable containerd

# Verify
if systemctl is-active --quiet containerd; then
  echo "✅ containerd is active and running"
else
  echo "❌ containerd failed to start, check logs with: journalctl -xeu containerd"
  exit 1
fi

echo "=== containerd installation completed successfully ==="

