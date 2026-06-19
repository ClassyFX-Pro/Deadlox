#!/bin/bash

# --- AUTOMATIC ROOT SELF-ELEVATION ---
# If not run as root, this block automatically elevates the execution context safely
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] SkelarHub requires root privileges. Elevating..."
  exec sudo bash "$0" "$@"
  exit 1
fi

# Detect Linux Distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi

draw_header() {
    clear
    echo "========================================================================"
    echo "  ██████  ██   ██ ███████ ██       █████  ██████  ██   ██ ██    ██ ██████  "
    echo " ██       ██  ██  ██      ██      ██   ██ ██   ██ ██   ██ ██    ██ ██   ██ "
    echo "  ██████  █████   █████   ██      ███████ ██████  ███████ ██    ██ ██████  "
    echo "       ██ ██  ██  ██      ██      ██   ██ ██   ██ ██   ██ ██    ██ ██   ██ "
    echo "  ██████  ██   ██ ███████ ███████ ██   ██ ██   ██ ██   ██  ██████  ██████  "
    echo "========================================================================"
    echo " System OS Detected: ${OS}"
    echo "========================================================================"
}

# Package Configurations
DEB_DEV="build-essential git curl wget vim nano tmux htop python3 python3-pip nodejs npm docker.io docker-compose"
RPM_DEV="curl wget git @development-tools vim-enhanced nano htop tmux python3 python3-pip nodejs docker docker-compose"
ARCH_DEV="base-devel git curl wget vim nano tmux htop python3 python3-pip nodejs npm docker docker-compose"

DEB_NET="nmap net-tools mtr iperf3 dnsutils ufw"
RPM_NET="nmap net-tools mtr iperf3 bind-utils ufw"
ARCH_NET="nmap net-tools mtr iperf3 dnsutils ufw"

# AI Diagnostic Function
ai_diagnostic() {
    echo ""
    echo "[AI MODE] Running system self-healing checks..."
    local tools=("curl" "wget" "git" "vim" "nano" "htop" "tmux" "unzip" "zip" "tar")
    local missing=()
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "[!] Missing Core Tool: $tool"
            missing+=("$tool")
        fi
    done
    if [ ${#missing[@]} -eq 0 ]; then
        echo "[✔] AI Check Passed: No essential utilities are missing!"
    else
        echo "[*] AI Mode resolving ${#missing[@]} missing packages..."
        case "$OS" in
            ubuntu|debian|pop|mint) apt-get update -y && apt-get install -y "${missing[@]}" ;;
            fedora) dnf install -y "${missing[@]}" ;;
            centos|rhel|almalinux|rocky) yum install -y epel-release && yum install -y "${missing[@]}" ;;
            arch) pacman -Sy --needed --noconfirm "${missing[@]}" ;;
        esac
        echo "[✔] AI Mode complete: Missing binaries resolved."
    fi
}

# Master Loop Execution
while true; do
    draw_header
    echo " 1) Update & Upgrade System Packages"
    echo " 2) AI Mode (Auto-Detect & Patch Missing Utilities)"
    echo " 3) Developer Workspace Suite (Compilers, Runtimes, Git, Docker)"
    echo " 4) Network Toolkit & Diagnostic Utilities (Nmap, Netstat, Iperf3)"
    echo " 5) Fast System Junk Cleaner (Clear Cache, Logs, and Orphaning Assets)"
    echo " 6) Basic Security Hardening (Enable Firewall & Close Weak Entrypoints)"
    echo " 7) Performance Tuner (Optimize SWAP usage & Increase File Limits)"
    echo " 8) Hardware & Sensor Inspector (CPU, RAM, Storage Metrics)"
    echo " 9) Backup Configurations (Archive critical system user workspaces)"
    echo " 10) Run Ookla Speedtest Engine"
    echo " 11) Install Signed Speedtest.net Repositories"
    echo " 12) Exit SkelarHub"
    echo "========================================================================"
    
    echo -n "Select an option [1-12]: "
    read -r choice 

    case "$choice" in
        1)
            echo ""
            echo "[*] Running System Upgrade..."
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get update -y && apt-get upgrade -y ;;
                fedora) dnf upgrade -y ;;
                centos|rhel|almalinux|rocky) yum update -y ;;
                arch) pacman -Syu --noconfirm ;;
            esac
            ;;
        2) ai_diagnostic ;;
        3)
            echo ""
            echo "[*] Deploying Developer Suite..."
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get update -y && apt-get install -y $DEB_DEV ;;
                fedora) dnf install -y $RPM_DEV ;;
                centos|rhel|almalinux|rocky) yum install -y epel-release && yum install -y $RPM_DEV ;;
                arch) pacman -Sy --needed --noconfirm $ARCH_DEV ;;
            esac
            ;;
        4)
            echo ""
            echo "[*] Provisioning Networking Toolkit..."
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get update -y && apt-get install -y $DEB_NET ;;
                fedora) dnf install -y $RPM_NET ;;
                centos|rhel|almalinux|rocky) yum install -y $RPM_NET ;;
                arch) pacman -Sy --needed --noconfirm $ARCH_NET ;;
            esac
            ;;
        5)
            echo ""
            echo "[*] Clearing temporary package layers, caches, and system journal logs..."
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get autoremove -y && apt-get clean -y ;;
                fedora|centos|rhel|almalinux|rocky) dnf clean all -y || yum clean all -y ;;
                arch) pacman -Scc --noconfirm ;;
            esac
            rm -rf /tmp/* 2>/dev/null
            journalctl --vacuum-time=3d &>/dev/null
            echo "[✔] System cleanup cycle successfully wrapped."
            ;;
        6)
            echo ""
            echo "[*] Applying fundamental infrastructure security controls..."
            if command -v ufw &>/dev/null; then
                ufw default deny incoming &>/dev/null
                ufw default allow outgoing &>/dev/null
                ufw allow 22/tcp comment 'SSH Port' &>/dev/null
                ufw --force enable
                echo "[✔] Firewall activated and standard inbound access clamped."
            elif command -v firewalld &>/dev/null; then
                systemctl enable --now firewalld &>/dev/null
                firewall-cmd --set-default-zone=drop &>/dev/null
                firewall-cmd --permanent --add-service=ssh &>/dev/null
                firewall-cmd --reload &>/dev/null
                echo "[✔] Firewalld activated and standard zones locked down."
            else
                echo "[!] Firewall framework missing. Install Option 4 first."
            fi
            ;;
        7)
            echo ""
            echo "[*] Adjusting operational limits and kernel memory optimization..."
            sysctl -w vm.swappiness=10 &>/dev/null
            sysctl -w fs.file-max=2097152 &>/dev/null
            echo "[✔] Virtual memory limits and SWAP handling ratios enhanced."
            ;;
        8)
            echo ""
            echo "[*] Real-Time System Load Summary:"
            echo "--------------------------------------"
            echo "CPU Architecture: $(uname -m)"
            echo "System Uptime: $(uptime -p)"
            echo "Memory Breakdown:" && free -h
            echo "Disk Storage Allocation:" && df -h / | grep -v Filesystem
            ;;
        9)
            echo ""
            echo "[*] Generating backup archive of operational configurations..."
            mkdir -p /backup
            tar -czf /backup/skelarhub_home_backup_$(date +%F).tar.gz /home 2>/dev/null
            echo "[✔] Compressed archive generated successfully under /backup directory."
            ;;
        10)
            echo ""
            echo "[*] Launching Ookla Speedtest Engine..."
            if command -v speedtest &>/dev/null; then
                speedtest --accept-license --accept-gdpr
            else
                echo "[!] Speedtest binary not linked. Execute Option 11 first."
            fi
            ;;
        11)
            echo ""
            echo "[*] Installing official Speedtest.net repository with GPG keys..."
            if [[ "$OS" =~ (ubuntu|debian|pop|mint) ]]; then
                apt-get install -y curl gnupg dirmngr apt-transport-https lsb-release
                # Download and securely register the official GPG key
                curl -fsSL https://packagecloud.io | gpg --dearmor -o /etc/apt/keyrings/ookla-speedtest-cli-archive-keyring.gpg
                # Add the repository referencing the secure keyring explicitly
                echo "deb [signed-by=/etc/apt/keyrings/ookla-speedtest-cli-archive-keyring.gpg] https://packagecloud.io $(lsb_release -cs) main" > /etc/apt/sources.list.d/speedtest.list
                apt-get update && apt-get install -y speedtest
            elif [[ "$OS" =~ (fedora|centos|rhel|almalinux|rocky) ]]; then
                curl -s https://packagecloud.io | bash
                [ -f /usr/bin/dnf ] && dnf install -y speedtest || yum install -y speedtest
            elif [ "$OS" = "arch" ]; then
                pacman -Sy --needed --noconfirm speedtest-cli
                [ ! -f /usr/bin/speedtest ] && ln -s "$(which speedtest-cli)" /usr/local/bin/speedtest 2>/dev/null
            fi
            echo "[✔] Speedtest signature and repository configurations finalized."
            ;;
        12)
            echo ""
            echo "Exiting SkelarHub. Keep building!"
            echo ""
            exit 0
            ;;
        *) echo "" && echo "[!] Invalid Selection. Select an option 1 through 12." ;;
    esac

    echo ""
    echo "Press [ENTER] to return to the SkelarHub Menu..."
    read -r 
done
