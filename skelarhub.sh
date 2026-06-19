#!/bin/bash

# --- AUTOMATIC SELF-HEALING PERMISSIONS & ELEVATION ---
# This block runs automatically at startup, applies chmod, elevates, and stops looping.
if [ -z "$SKELAR_ELEVATED" ]; then
    SCRIPT_PATH=$(readlink -f "$0")
    
    # Automatically apply execution permissions if missing
    if [ ! -x "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
    fi
    
    # Export flag and re-execute safely with root privileges
    export SKELAR_ELEVATED=1
    if [ "$EUID" -ne 0 ]; then
        exec sudo -E bash "$SCRIPT_PATH" "$@"
    else
        exec bash "$SCRIPT_PATH" "$@"
    fi
fi

# Detect Linux Distribution
[ -f /etc/os-release ] && . /etc/os-release && OS=$ID || OS="unknown"

# Unified Installer Helper Function
pkg_install() {
    case "$OS" in
        ubuntu|debian|pop|mint) apt-get update -qq && apt-get install -y $1 ;;
        fedora) dnf install -y $1 ;;
        centos|rhel|almalinux|rocky) yum install -y epel-release && yum install -y $1 ;;
        arch) pacman -Sy --needed --noconfirm $1 ;;
    esac
}

while true; do
    clear
    echo "======================================================================================================================"
    echo "  ███████╗██║  ██╗███████╗██║      █████╗ ██████╗ ██╗  ██╗██╗   ██╗██████╗ "
    echo "  ██╔════╝██║ ██╔╝██╔════╝██║     ██╔══██╗██╔══██╗██║  ██║██║   ██║██╔══██╗"
    echo "  ███████╗█████╔╝ █████╗  ██║     ███████║██████╔╝███████║██║   ██║██████╔╝"
    echo "  ╚════██║██╔═██╗ ██╔══╝  ██║     ██╔══██║██╔══██╗██╔══██║██║   ██║██╔══██╗"
    echo "  ███████║██║  ██╗███████╗███████╗██║  ██║██║  ██║██║  ██║╚██████╔╝██████╔╝"
    echo "  ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ "
    echo "======================================================================================================================"
    echo " System OS Detected: $OS"
    echo "======================================================================================================================"
    echo " 1) Upgrade System"
    echo " 2) AI Self-Healing Core Checks"
    echo " 3) Developer Workspace Suite"
    echo " 4) Network Diagnostic Toolkit"
    echo " 5) Fast Junk Cleaner"
    echo " 6) Basic Security Hardening"
    echo " 7) Performance Kernel Tuner"
    echo " 8) Hardware & Sensor Inspector"
    echo " 9) Archive Backup System"
    echo " 10) Port Knocking Router Guard"
    echo " 11) Run Ookla Speedtest Engine"
    echo " 12) Install Speedtest.net Repository"
    echo " 13) Install UFW / Firewalld Engine"
    echo " 14) Exit SkelarHub Framework"
    echo "======================================================================================================================"
    echo -n "Select an option [1-14]: " && read -r choice

    case "$choice" in
        1)  
            echo "[*] Upgrading..."
            if [ "$OS" = "arch" ]; then 
                pacman -Syu --noconfirm
            elif [ "$OS" = "fedora" ]; then 
                dnf upgrade -y
            elif [[ "$OS" =~ (ubuntu|debian|pop|mint) ]]; then 
                apt-get update -y && apt-get upgrade -y
            else 
                yum update -y
            fi 
            ;;

        2)  
            echo "[*] Running AI Core..." 
            missing=()
            for t in curl wget git vim nano htop tmux unzip zip tar; do 
                if ! command -v "$t" &>/dev/null; then
                    missing+=("$t")
                fi
            done
            if [ ${#missing[@]} -gt 0 ]; then
                pkg_install "${missing[*]}" 
            else
                echo "[✔] Everything installed." 
            fi
            ;;

        3)  
            echo "[*] Installing Developer Workspace Suite..."
            if [ "$OS" = "arch" ]; then 
                pkg_install "base-devel git curl wget vim nano tmux htop python python-pip nodejs npm docker docker-compose"
            elif [[ "$OS" =~ (centos|rhel|almalinux|rocky) ]]; then 
                pkg_install "git curl wget vim nano tmux htop python3 python3-pip nodejs npm" 
                if [ ! -x "$(command -v docker)" ]; then
                    curl -fsSL https://docker.com | sh
                fi
            else 
                pkg_install "build-essential git curl wget vim nano tmux htop python3 python3-pip nodejs npm docker.io docker-compose"
            fi
            
            if [ -x "$(command -v systemctl)" ]; then
                systemctl enable --now docker &>/dev/null 
            fi
            ;;

        4)  
            echo "[*] Installing Network Diagnostic Toolkit..."
            if [ "$OS" = "arch" ]; then 
                pkg_install "nmap net-tools mtr iperf3 dnsutils ufw"
            elif [[ "$OS" =~ (fedora|centos|rhel|almalinux|rocky) ]]; then 
                pkg_install "nmap net-tools mtr iperf3 bind-utils ufw"
            else 
                pkg_install "nmap net-tools mtr iperf3 dnsutils ufw"
            fi 
            ;;

        5)  
            echo "[*] Cleaning..."
            if [ -f /usr/bin/apt-get ]; then
                apt-get autoremove -y && apt-get clean -y
            fi
            if [ -f /usr/bin/dnf ]; then
                dnf clean all -y
            fi
            if [ -f /usr/bin/yum ] ; then
                yum clean all -y
            fi
            if [ "$OS" = "arch" ]; then
                pacman -Scc --noconfirm
            fi
            rm -rf /tmp/* 2>/dev/null
            if [ -x "$(command -v journalctl)" ]; then
                journalctl --vacuum-time=3d &>/dev/null 
            fi
            ;;

        6)  
            echo "[*] Applying Basic Security Hardening..."
            if command -v ufw &>/dev/null; then 
                ufw default deny incoming 
                ufw default allow outgoing 
                ufw allow 22/tcp 
                ufw --force enable
            else
                echo "[!] Run Option 13 or Option 4 first to get firewall engine utilities." 
            fi 
            ;;

        7)  
            echo "[*] Applying Performance Kernel Tuner tweaks..."
            sysctl -w vm.swappiness=10 fs.file-max=2097152 &>/dev/null 
            echo "[✔] Performance rules appended to runtime."
            ;;

        8)  
            echo "[*] Fetching Hardware Metrics Snapshot..."
            echo "CPU Architecture: $(uname -m)"
            echo "System Host Uptime: $(uptime -p)" 
            echo "-----------------------------------"
            free -h 
            echo "-----------------------------------"
            df -h / | grep -v Filesystem 
            ;;

        9)  
            echo "[*] Starting Archive Backup System..."
            mkdir -p /backup 
            tar -czf /backup/skelarhub_backup_$(date +%F).tar.gz /home 2>/dev/null 
            echo "[✔] Backup finished inside /backup" 
            ;;

        10) 
            echo "[*] Installing Port Knocking Router Guard..."
            pkg_install "knockd" 
            ;;

        11) 
            echo "[*] Launching Ookla Speedtest Network Engine..."
            if command -v speedtest &>/dev/null; then
                speedtest --accept-license --accept-gdpr 
            else
                echo "[!] Run Option 12 first to link repositories." 
            fi
            ;;

        12) 
            echo "[*] Downloading official Ookla network engine repository configurations..."
            if [[ "$OS" =~ (ubuntu|debian|pop|mint) ]]; then
                apt-get install -y curl gnupg 
                curl -s https://packagecloud.io | bash 
                apt-get update 
                apt-get install -y speedtest
            elif [[ "$OS" =~ (fedora|centos|rhel|almalinux|rocky) ]]; then
                curl -s https://packagecloud.io | bash 
                if [ -f /usr/bin/dnf ]; then
                    dnf install -y speedtest 
                else
                    yum install -y speedtest
                fi
            elif [ "$OS" = "arch" ]; then
                pacman -Sy --needed --noconfirm speedtest-cli 
                if [ ! -f /usr/bin/speedtest ]; then
                    ln -s "$(which speedtest-cli)" /usr/local/bin/speedtest 2>/dev/null
                fi
            fi 
            ;;

        13) 
            echo "[*] Deploying Dedicated Firewall Architecture..."
            if [ "$OS" = "fedora" ] || [[ "$OS" =~ (centos|rhel|almalinux|rocky) ]]; then 
                pkg_install "firewalld"
            else 
                pkg_install "ufw"
            fi 
            ;;

        14) 
            echo "Exiting SkelarHub Framework. Goodbye!" 
            exit 0 
            ;;

        *)  
            echo "[!] Invalid Selection. Please pick a number from 1 to 14." 
            ;;
    esac

    echo "" 
    echo "Press [ENTER] to return to the Menu..." 
    read -r
done
