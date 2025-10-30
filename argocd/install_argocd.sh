#!/bin/bash
set -euo pipefail

# Define namespace for ArgoCD
NAMESPACE="argocd"
RELEASE_NAME="argocd"

echo ">>> Creating namespace '$NAMESPACE'..."
kubectl create namespace "$NAMESPACE" || true

echo ">>> Adding ArgoCD Helm repository..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

echo ">>> Installing ArgoCD into '$NAMESPACE'..."
helm install $RELEASE_NAME argo/argo-cd \
  --namespace "$NAMESPACE" \
  --set server.ingress.enabled=false \
  --set server.service.type=LoadBalancer \
  --wait

echo "✅ ArgoCD installed successfully!"

echo "--- Initial Login Details ---"
echo "Wait a few moments for the LoadBalancer IP to be assigned."
echo "To get the service IP (if using LoadBalancer):"
echo 'kubectl get svc -n argocd argocd-server -o jsonpath="{.status.loadBalancer.ingress[0].ip}"'

echo "To get the initial admin password:"
echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
echo ""
echo "Use username 'admin' and the retrieved password to log in."
