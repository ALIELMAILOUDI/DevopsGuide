#!/bin/bash
set -e

# Colors for pretty logs
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}=== Kubernetes Setup Orchestrator ===${RESET}"

# Function to run each step
run_step() {
    STEP_NAME=$1
    SCRIPT=$2
    echo -e "\n${YELLOW}>>> Starting: $STEP_NAME ...${RESET}"
    chmod +x "$SCRIPT"
    if bash "$SCRIPT"; then
        echo -e "${GREEN}✔ $STEP_NAME completed successfully.${RESET}"
    else
        echo -e "${RED}✖ $STEP_NAME failed! Aborting.${RESET}"
        exit 1
    fi
}

# 1️⃣ Install Docker
run_step "Docker installation" "./install_docker.sh"

# 2️⃣ Install Containerd
run_step "Containerd installation" "./install_containerd.sh"

# 3️⃣ Install Kubernetes (kubeadm, kubelet, kubectl)
run_step "Kubernetes installation" "./install_k8s.sh"

# 4️⃣ Reset & initialize Kubernetes cluster (optional)
if [ -f "./k8s-reset-init.sh" ]; then
    read -p "Do you want to reset & initialize Kubernetes cluster now? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        run_step "Kubernetes reset & init" "./k8s-reset-init.sh"
    else
        echo -e "${YELLOW}Skipping cluster initialization.${RESET}"
    fi
fi

# 5️⃣ Install Helm
run_step "Helm installation" "./install_helm.sh"

# 6️⃣ Install Traefik via Helm
run_step "Traefik installation" "./install_traefik.sh"

echo -e "\n${GREEN}=== All steps completed successfully! Your cluster is ready. ===${RESET}"
