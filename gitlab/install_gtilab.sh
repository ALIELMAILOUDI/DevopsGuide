#!/bin/bash
set -e

echo "=== Installing GitLab ==="

# Install dependencies
apt update -y
apt install -y curl openssh-server ca-certificates tzdata perl

# Add GitLab repository and install
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash
EXTERNAL_URL="http://$(hostname -I | awk '{print $1}')" apt install -y gitlab-ce

echo "✅ GitLab installation completed"
