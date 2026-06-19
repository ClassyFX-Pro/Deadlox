#!/bin/bash

# --- ROOT ELEVATION ---
[ "$EUID" -ne 0 ] && echo "[ERROR] Run with root privileges." && exec sudo bash "$0" "$@" && exit 1

# Detect Linux Distribution
[ -f /etc/os-release ] && . /etc/os-release && OS=$ID || OS="unknown"

# Unified Installer Helper Function
pkg_install() {
    case "$OS" in
        ubuntu|debian|pop|mint) apt-get update -y && apt-get install -y $1 ;;
        fedora) dnf install -y $1 ;;
        centos|rhel|almalinux|rocky) yum install -y epel-release && yum install -y $1 ;;
        arch) pacman -Sy --needed --noconfirm $1 ;;
    esac
}

while true; do
    clear
    echo "======================================================================================================================"
    echo "  ███████╗██╗  ██╗███████╗██╗      █████╗ ██████╗ ██╗  ██╗██╗   ██╗██████╗ "
    echo "  ██╔════╝██║  ██║██╔════╝██║     ██╔══██╗██╔══██╗██║  ██║██║   ██║██╔══██╗"
    echo "  ███████╗███████║█████╗  ██║     ███████║██████╔╝███████║██║   ██║██████╔╝"
    echo "  ╚════██║██╔══██║██╔══╝  ██║     ██╔══██║██╔══██╗██╔══██║██║   ██║██╔══██╗"
    echo "  ███████║██║  ██║███████╗███████╗██║  ██║██║  ██║██║  ██║╚██████╔╝██████╔╝"
    echo "  ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ "
    echo "======================================================================================================================"
    echo " System OS Detected: $OS"
    echo "======================================================================================================================"
    echo " 1) Upgrade System"
    echo " 2) AI Self-Healing Core"
    echo " 3) Developer Workspace Suite"
    echo " 4) Network Diagnostic Toolkit"
    echo " 5) Fast Junk Cleaner"
    echo " 6) Basic Security Hardening"
    echo " 7) Performance Kernel Tuner"
    echo " 8) Hardware & Sensor Inspector"
    echo " 9) Archive Backup System"
    echo " 10) Port Knocking Router Guard"
    echo " 11) Run Ookla Speedtest"
    echo " 12) Install Speedtest.net Engine"
    echo " 13) Exit SkelarHub"
    echo "======================================================================================================================"
    echo -n "Select an option [1-13]: " && read -r choice

    case "$choice" in
        1)  echo "[*] Upgrading..."
            [ "$OS" = "arch" ] && pacman -Syu --noconfirm || ([ "$OS" = "fedora" ] && dnf upgrade -y) || ([ -f /usr/bin/apt-get ] && apt-get update -y && apt-get upgrade -y) || yum update -y ;;
        2)  echo "[*] Running AI Core..." && missing=()
            for t in curl wget git vim nano htop tmux unzip zip tar; do ! command -v "$t" &>/dev/null && missing+=("$t"); done
            [ ${#missing[@]} -gt 0 ] && pkg_install "${missing[*]}" || echo "[✔] Everything installed." ;;
        3)  pkg_install "build-essential git curl wget vim nano tmux htop python3 python3-pip nodejs npm docker.io docker-compose" ;;
        4)  pkg_install "nmap net-tools mtr iperf3 dnsutils ufw" ;;
        5)  echo "[*] Cleaning..."
            [ -f /usr/bin/apt-get ] && apt-get autoremove -y && apt-get clean -y
            [ -f /usr/bin/dnf ] && dnf clean all -y || ([ -f /usr/bin/yum ] && yum clean all -y)
            [ "$OS" = "arch" ] && pacman -Scc --noconfirm
            rm -rf /tmp/* 2>/dev/null && journalctl --vacuum-time=3d &>/dev/null ;;
        6)  command -v ufw &>/dev/null && (ufw default deny incoming && ufw default allow outgoing && ufw allow 22/tcp && ufw --force enable) || echo "[!] Run Option 4 first." ;;
        7)  sysctl -w vm.swappiness=10 fs.file-max=2097152 &>/dev/null ;;
        8)  echo "CPU: $(uname -m) | Uptime: $(uptime -p)" && free -h && df -h / | grep -v Filesystem ;;
        9)  mkdir -p /backup && tar -czf /backup/skelarhub_backup_$(date +%F).tar.gz /home 2>/dev/null ;;
        10) pkg_install "knockd" ;;
        11) command -v speedtest &>/dev/null && speedtest --accept-license --accept-gdpr || echo "[!] Run Option 12 first." ;;
        12) echo "[*] Downloading official Ookla network engine repository configurations..."
            if [[ "$OS" =~ (ubuntu|debian|pop|mint) ]]; then
                apt-get install -y curl gnupg && curl -s https://packagecloud.io | bash && apt-get update && apt-get install -y speedtest
            elif [[ "$OS" =~ (fedora|centos|rhel|almalinux|rocky) ]]; then
                curl -s https://packagecloud.io | bash && ([ -f /usr/bin/dnf ] && dnf install -y speedtest || yum install -y speedtest)
            elif [ "$OS" = "arch" ]; then
                pacman -Sy --needed --noconfirm speedtest-cli && [ ! -f /usr/bin/speedtest ] && ln -s $(which speedtest-cli) /usr/local/bin/speedtest 2>/dev/null
            fi ;;
        13) echo "Exiting." && exit 0 ;;
        *)  echo "[!] Invalid Selection." ;;
    esac
    echo "" && echo "Press [ENTER] to return to the Menu..." && read -r
done
