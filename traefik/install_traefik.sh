#!/bin/bash
set -e

echo "=== STEP: Installing Traefik Ingress Controller ==="

# Create the namespace if it doesn't exist
kubectl get namespace traefik >/dev/null 2>&1 || kubectl create namespace traefik
echo "✅ Namespace 'traefik' ready"

# Add and update the Helm repo
echo "📦 Adding Traefik Helm repository..."
helm repo add traefik https://traefik.github.io/charts >/dev/null 2>&1
helm repo update >/dev/null 2>&1
echo "✅ Helm repo updated"

# Choose a version compatible with redirectTo object syntax
TRAEFIK_VERSION="33.0.0"

# Install or upgrade Traefik
echo "🚀 Installing Traefik with Helm..."
helm upgrade --install traefik traefik/traefik \
  --namespace traefik \
  --version ${TRAEFIK_VERSION} \
  --set service.type=LoadBalancer \
  --set ports.web.redirectTo.port=websecure \
  --set ports.websecure.tls.enabled=true \
  --set ingressClass.enabled=true \
  --set ingressClass.isDefaultClass=true

echo "✅ Traefik installed successfully!"
echo "🌐 To check Traefik status: kubectl get svc -n traefik"
