#!/bin/bash
set -e

echo "=== STEP 1: Installing Helm ==="

# Remove old versions if exist
sudo rm -f /usr/local/bin/helm

# Download and install the latest Helm binary
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installation
helm version

echo "=== Helm installed successfully ==="
