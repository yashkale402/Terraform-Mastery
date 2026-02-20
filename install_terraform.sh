#!/bin/bash

# Color variables for output
LIGHTGREEN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m'

# Exit on error
set -e

echo -e "${LIGHTGREEN}Starting Terraform Installation...${NC}"

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]]; then
    SUDO="sudo"
else
    SUDO=""
fi

# Install dependencies
$SUDO apt-get update -y
$SUDO apt-get install -y gnupg software-properties-common curl wget lsb-release

# Download and add HashiCorp GPG key (Updated method)
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    $SUDO tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Verify the key fingerprint (optional but recommended)
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    $SUDO tee /etc/apt/sources.list.d/hashicorp.list

# Update and install Terraform
$SUDO apt-get update -y
$SUDO apt-get install -y terraform

# Verify installation
if command -v terraform &> /dev/null; then
    echo -e "${LIGHTGREEN}✔ Terraform Installed Successfully!${NC}"
    echo -e "Terraform version: ${LIGHTGREEN}$(terraform version)${NC}"
else
    echo -e "${RED}✘ Terraform installation failed!${NC}"
    exit 1
fi