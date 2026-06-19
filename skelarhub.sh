#!/bin/bash

# --- ROOT ELEVATION ---
if [ "$EUID" -ne 0 ] ; then
  echo "[ERROR] SkelarHub requires root privileges."
  exec sudo bash "$0" "$@"
  exit 1
fi

# Detect Linux Distribution
[ -f /etc/os-release ] && . /etc/os-release && OS=$ID || OS="unknown"

# Package Constants
D_DEV="build-essential git curl wget vim nano htop tmux unzip zip tar python3 python3-pip nodejs npm docker.io docker-compose"
R_DEV="curl wget git @development-tools vim-enhanced nano htop tmux unzip zip tar python3 python3-pip nodejs docker docker-compose"
A_DEV="base-devel git curl wget vim nano tmux htop unzip zip tar python3 python3-pip nodejs npm docker docker-compose"
D_NET="nmap net-tools mtr iperf3 dnsutils ufw"
R_NET="nmap net-tools mtr iperf3 bind-utils ufw"

draw_header() {
    clear
    echo "========================================================="
    echo "  ██████  ██   ██ ███████ ██       █████  ██████   "
    echo " ██       ██  ██  ██      ██      ██   ██ ██   ██  "
    echo "  ██████  █████   █████   ██      ███████ ██████   "
    echo "       ██ ██  ██  ██      ██      ██   ██ ██   ██  "
    echo "  ██████  ██   ██ ███████ ███████ ██   ██ ██   ██  "
    echo "========================================================="
    echo " System OS Detected: ${OS}"
    echo "========================================================="
}

while true; do
    draw_header
    echo " 1) Upgrade System Packages"
    echo " 2) AI Self-Healing Core Checks"
    echo " 3) Developer Workspace Suite Deploy"
    echo " 4) Network Toolkit & Diagnostic Utilities"
    echo " 5) Fast System Junk Cleaner Routine"
    echo " 6) Basic Infrastructure Security Hardening"
    echo " 7) Performance Tuner Profiles"
    echo " 8) Hardware & Sensor Inspector Metrics"
    echo " 9) Backup Configurations Workspace Archiver"
    echo " 10) Run Ookla Speedtest Engine"
    echo " 11) Install Signed Speedtest.net Repositories"
    echo " 12) Download & Install Speedtest Binary Engine"
    echo " 13) Exit SkelarHub Framework"
    echo "========================================================="
    echo -n "Select an option [1-13]: " && read -r choice 

    case "$choice" in
        1)  echo -e "\n[*] Upgrading..."
            [[ "$OS" =~ (ubuntu|debian|pop|mint) ]] && apt-get update -y && apt-get upgrade -y
            [ "$OS" = "fedora" ] && dnf upgrade -y
            [[ "$OS" =~ (centos|rhel|almalinux|rocky) ]] && yum update -y
            [ "$OS" = "arch" ] && pacman -Syu --noconfirm ;;
        2)  echo -e "\n[*] Running AI Core checks..."
            local tools=("curl" "wget" "git" "vim" "nano" "htop" "tmux" "unzip" "zip" "tar")
            local missing=()
            for t in "${tools[@]}"; do ! command -v "$t" &>/dev/null && missing+=("$t"); done
            if [ ${#missing[@]} -gt 0 ]; then
                [[ "$OS" =~ (ubuntu|debian|pop|mint) ]] && apt-get update -y && apt-get install -y "${missing[@]}"
                [ "$OS" = "fedora" ] && dnf install -y "${missing[@]}"
                [[ "$OS" =~ (centos|rhel|almalinux|rocky) ]] && yum install -y epel-release && yum install -y "${missing[@]}"
                [ "$OS" = "arch" ] && pacman -Sy --needed --noconfirm "${missing[@]}"
            else echo "[✔] Core systems functional."; fi ;;
        3)  echo -e "\n[*] Deploying Developer Workspace..."
            [[ "$OS" =~ (ubuntu|debian|pop|mint) ]] && apt-get update -y && apt-get install -y $DEB_DEV
            [ "$OS" = "fedora" ] && dnf install -y $RPM_DEV
            [[ "$OS" =~ (centos|rhel|almalinux|rocky) ]] && yum install -y epel-release && yum install -y $RPM_DEV
            [ "$OS" = "arch" ] && pacman -Sy --needed --noconfirm $ARCH_DEV
            [ -x "$(command -v systemctl)" ] && systemctl enable --now docker &>/dev/null ;;
        4)  echo -e "\n[*] Deploying Network diagnostic tools..."
            [[ "$OS" =~ (ubuntu|debian|pop|mint) ]] && apt-get update -y && apt-get install -y $DEB_NET
            [ "$OS" = "fedora" ] && dnf install -y $RPM_NET
            [[ "$OS" =~ (centos|rhel|almalinux|rocky) ]] && yum install -y $RPM_NET
            [ "$OS" = "arch" ] && pacman -Sy --needed --noconfirm $ARCH_NET ;;
        5)  echo -e "\n[*] Wiping caches and logs..."
            [[ "$OS" =~ (ubuntu|debian|pop|mint) ]] && apt-get autoremove -y && apt-get clean -y
            [[ "$OS" =~ (fedora|centos|rhel|almalinux|rocky) ]] && dnf clean all -y || yum clean all -y
            [ "$OS" = "arch" ] && pacman -Scc --noconfirm
            rm -rf /tmp/* 2>/dev/null && journalctl --vacuum-time=3d &>/dev/null ;;
        6)  echo -e "\n[*] Applying baseline firewall mappings..."
            if command -v ufw &>/dev/null; then
                ufw default deny incoming &>/dev/null && ufw default allow outgoing &>/dev/null
                ufw allow 22/tcp &>/dev/null && ufw --force enable && echo "[✔] Firewall loaded."
            elif command -v firewalld &>/dev/null; then
                systemctl enable --now firewalld &>/dev/null && firewall-cmd --set-default-zone=drop &>/dev/null
                firewall-cmd --permanent --add-service=ssh &>/dev/null && firewall-cmd --reload &>/dev/null
                echo "[✔] Security zones secured."
            else echo "[!] Firewall package missing. Run option 4 first."; fi ;;
        7)  echo -e "\n[*] Tuning swappiness and file descriptors..."
            sysctl -w vm.swappiness=10 fs.file-max=2097152 &>/dev/null ;;
        8)  echo -e "\n[*] Node System Metrics load summary:\nCPU: $(uname -m) | Uptime: $(uptime -p)"
            free -h && df -h / | grep -v Filesystem ;;
        9)  echo -e "\n[*] Packing workspaces..."
            mkdir -p /backup && tar -czf /backup/skelarhub_backup_$(date +%F).tar.gz /home 2>/dev/null ;;
        10) echo -e "\n[*] Triggering network assessment metrics..."
            speedtest --accept-license --accept-gdpr ;;
        11) echo -e "\n[*] Mapping secure Speedtest infrastructure sign keys..."
            if [[ "$OS" =~ (ubuntu|debian|pop|mint) ]]; then
                apt-get install -y curl gpg dirmngr apt-transport-https lsb-release
                mkdir -p /etc/apt/keyrings
                curl -fsSL "https://packagecloud.io" | gpg --yes --dearmor -o /etc/apt/keyrings/ookla-speedtest-cli-archive-keyring.gpg
                local t_dist="ubuntu" && [ "$OS" = "debian" ] && t_dist="debian"
                echo "deb [signed-by=/etc/apt/keyrings/ookla-speedtest-cli-archive-keyring.gpg] https://packagecloud.io{t_dist} $(lsb_release -cs) main" > /etc/apt/sources.list.d/speedtest.list
            elif [[ "$OS" =~ (fedora|centos|rhel|almalinux|rocky) ]]; then
                curl -s https://packagecloud.io | bash
            fi ;;
        12) echo -e "\n[*] Syncing engine client core libraries..."
            if [[ "$OS" =~ (ubuntu|debian|pop|mint) ]]; then apt-get update && apt-get install -y speedtest
            elif [[ "$OS" =~ (fedora|centos|rhel|almalinux|rocky) ]]; then [ -f /usr/bin/dnf ] && dnf install -y speedtest || yum install -y speedtest
            elif [ "$OS" = "arch" ]; then pacman -Sy --needed --noconfirm speedtest-cli
                [ ! -f /usr/bin/speedtest ] && ln -s "$(which speedtest-cli)" /usr/local/bin/speedtest 2>/dev/null; fi ;;
        13) echo -e "\nExiting SkelarHub." && exit 0 ;;
        *)  echo -e "\n[!] Selection out of bounds." ;;
    esac
    echo -e "\nPress [ENTER] to continue..." && read -r
done
