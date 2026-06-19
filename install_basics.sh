#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script using sudo or as root."
  exit 1
fi

# Define the basic packages to install
# Core utilities: curl, wget, git, build tools, text editors, and system monitors
DEB_PACKAGES="curl wget git build-essential vim nano htop tmux unzip zip tar"
RPM_PACKAGES="curl wget git @development-tools vim-enhanced nano htop tmux unzip zip tar"
ARCH_PACKAGES="curl wget git base-devel vim nano htop tmux unzip zip tar"

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect Linux distribution. Exiting."
    exit 1
fi

echo "Detected OS: $OS"
echo "Starting system update and basic package installation..."

case "$OS" in
    ubuntu|debian|pop|mint)
        echo "Updating package lists..."
        apt-get update -y
        echo "Installing basic packages..."
        apt-get install -y $DEB_PACKAGES
        ;;
        
    fedora)
        echo "Updating package lists..."
        dnf check-update
        echo "Installing basic packages..."
        dnf install -y $RPM_PACKAGES
        ;;
        
    centos|rhel|almalinux|rocky)
        echo "Updating package lists..."
        yum check-update
        echo "Installing basic packages..."
        yum install -y epel-release # Enables extra packages like htop
        yum install -y $RPM_PACKAGES
        ;;
        
    arch)
        echo "Updating package lists..."
        pacman -Syu --noconfirm
        echo "Installing basic packages..."
        pacman -S --needed --noconfirm $ARCH_PACKAGES
        ;;
        
    *)
        echo "Unsupported distribution: $OS"
        exit 1
        ;;
esac

echo "Success! All basic packages have been installed."
