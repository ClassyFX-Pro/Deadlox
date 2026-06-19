cat << 'EOF' > skelarhub.sh
#!/bin/bash

# --- SELF-PERMISSIVE WRAPPER ---
if [ ! -x "$0" ]; then
    chmod +x "$0" 2>/dev/null
    exec "$0" "$@"
fi

# Ensure the script is run with sudo privileges
if [ "$EUID" -ne 0 ]; then
  echo -e "\033[0;31m\033[1m[ERROR]\033[0m Please run SkelarHub using sudo: sudo ./skelarhub.sh"
  exit 1
fi

# Define Standard Colors for Menu Text
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Detect Linux Distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi

# Pixel-by-Pixel RGB Engine for ASCII banner
print_rgb_line() {
    local text="$1"
    local row_offset="$2"
    local len=${#text}
    local colors=(196 202 208 214 220 226 190 154 118 82 46 47 48 49 51 45 39 33 27 21 57 93 129 165 201 200 199 198 197)
    local num_colors=${#colors[@]}

    for (( i=0; i<len; i++ )); do
        local char="${text:$i:1}"
        local color_index=$(( (i + row_offset) % num_colors ))
        local color_code=${colors[$color_index]}
        printf "\033[38;5;${color_code}m%s" "$char"
    done
    echo -e "${RESET}"
}

draw_header() {
    clear
    print_rgb_line "  ██████  ██   ██ ███████ ██       █████  ██████  ██   ██ ██    ██ ██████  " 0
    print_rgb_line " ██       ██  ██  ██      ██      ██   ██ ██   ██ ██   ██ ██    ██ ██   ██ " 3
    print_rgb_line "  ██████  █████   █████   ██      ███████ ██████  ███████ ██    ██ ██████  " 6
    print_rgb_line "       ██ ██  ██  ██      ██      ██   ██ ██   ██ ██   ██ ██    ██ ██   ██ " 9
    print_rgb_line "  ██████  ██   ██ ███████ ███████ ██   ██ ██   ██ ██   ██  ██████  ██████  " 12
    echo -e "${CYAN}${BOLD}========================================================================${RESET}"
    echo -e "${BLUE}${BOLD} System OS Detected:${RESET} ${YELLOW}${OS}${RESET}"
    echo -e "${CYAN}${BOLD}========================================================================${RESET}"
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
    echo -e "\n\033[38;5;129m${BOLD}[AI MODE] Running system self-healing checks...${RESET}"
    local tools=("curl" "wget" "git" "vim" "nano" "htop" "tmux" "unzip" "zip" "tar")
    local missing=()
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${YELLOW}[!] Missing Core Tool:${RESET} $tool"
            missing+=("$tool")
        fi
    done
    if [ ${#missing[@]} -eq 0 ]; then
        echo -e "${GREEN}${BOLD}[✔] AI Check Passed: No essential utilities are missing!${RESET}"
    else
        echo -e "${CYAN}[*] AI Mode resolving ${#missing[@]} missing packages...${RESET}"
        case "$OS" in
            ubuntu|debian|pop|mint) apt-get update -y && apt-get install -y "${missing[@]}" ;;
            fedora) dnf install -y "${missing[@]}" ;;
            centos|rhel|almalinux|rocky) yum install -y epel-release && yum install -y "${missing[@]}" ;;
            arch) pacman -Sy --needed --noconfirm "${missing[@]}" ;;
        esac
        echo -e "${GREEN}${BOLD}[✔] AI Mode complete: Missing binaries resolved.${RESET}"
    fi
}

while true; do
    draw_header
    echo -e "${GREEN}${BOLD} 1)${RESET} Update & Upgrade System Packages"
    echo -e "${GREEN}${BOLD} 2)${RESET} AI Mode (Auto-Detect & Patch Missing Utilities)"
    echo -e "${GREEN}${BOLD} 3)${RESET} Developer Workspace Suite (Compilers, Runtimes, Git, Docker)"
    echo -e "${GREEN}${BOLD} 4)${RESET} Network Toolkit & Diagnostic Utilities (Nmap, Netstat, Iperf3)"
    echo -e "${GREEN}${BOLD} 5)${RESET} Fast System Junk Cleaner (Clear Cache, Logs, and Orphaning Assets)"
    echo -e "${GREEN}${BOLD} 6)${RESET} Basic Security Hardening (Enable Firewall & Close Weak Entrypoints)"
    echo -e "${GREEN}${BOLD} 7)${RESET} Performance Tuner (Optimize SWAP usage & Increase File Limits)"
    echo -e "${GREEN}${BOLD} 8)${RESET} Hardware Hardware & Sensor Inspector (CPU, RAM, Storage Metrics)"
    echo -e "${GREEN}${BOLD} 9)${RESET} Backup Configurations (Archive critical system user workspaces)"
    echo -e "${RED}${BOLD} 10)${RESET} Exit SkelarHub"
    echo -e "${CYAN}${BOLD}========================================================================${RESET}"
    
    echo -n -e "${YELLOW}${BOLD}Select an option [1-10]: ${RESET}"
    read -r choice < /dev/tty 

    case $choice in
        1)
            echo -e "\n${BLUE}${BOLD}[*] Running System Upgrade...${RESET}"
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get update -y && apt-get upgrade -y ;;
                fedora) dnf upgrade -y ;;
                centos|rhel|almalinux|rocky) yum update -y ;;
                arch) pacman -Syu --noconfirm ;;
            esac
            ;;
        2) ai_diagnostic ;;
        3)
            echo -e "\n${BLUE}${BOLD}[*] Deploying Developer Suite...${RESET}"
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get update -y && apt-get install -y $DEB_DEV ;;
                fedora) dnf install -y $RPM_DEV ;;
                centos|rhel|almalinux|rocky) yum install -y epel-release && yum install -y $RPM_DEV ;;
                arch) pacman -Sy --needed --noconfirm $ARCH_DEV ;;
            esac
            ;;
        4)
            echo -e "\n${BLUE}${BOLD}[*] Provisioning Networking Toolkit...${RESET}"
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get update -y && apt-get install -y $DEB_NET ;;
                fedora) dnf install -y $RPM_NET ;;
                centos|rhel|almalinux|rocky) yum install -y $RPM_NET ;;
                arch) pacman -Sy --needed --noconfirm $ARCH_NET ;;
            esac
            ;;
        5)
            echo -e "\n${BLUE}${BOLD}[*] Clearing temporary package layers, caches, and system journal logs...${RESET}"
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get autoremove -y && apt-get clean -y ;;
                fedora|centos|rhel|almalinux|rocky) dnf clean all -y || yum clean all -y ;;
                arch) pacman -Scc --noconfirm ;;
            esac
            rm -rf /tmp/* 2>/dev/null
            journalctl --vacuum-time=3d &>/dev/null
            echo -e "${GREEN}${BOLD}[✔] System cleanup cycle successfully wrapped.${RESET}"
            ;;
        6)
            echo -e "\n${BLUE}${BOLD}[*] Applying fundamental infrastructure security controls...${RESET}"
            if command -v ufw &> /dev/null; then
                ufw default deny incoming &>/dev/null
                ufw default allow outgoing &>/dev/null
                ufw allow 22/tcp comment 'SSH Port' &>/dev/null
                ufw --force enable
                echo -e "${GREEN}${BOLD}[✔] Firewall activated and standard inbound access clamped.${RESET}"
            else
                echo -e "${RED}[!] Firewall framework (UFW) missing. Install Option 4 first.${RESET}"
            fi
            ;;
        7)
            echo -e "\n${BLUE}${BOLD}[*] Adjusting operational limits and kernel memory optimization...${RESET}"
            sysctl -w vm.swappiness=10 &>/dev/null
            sysctl -w fs.file-max=2097152 &>/dev/null
            echo -e "${GREEN}${BOLD}[✔] Virtual memory limits and SWAP handling ratios enhanced.${RESET}"
            ;;
        8)
            echo -e "\n${BLUE}${BOLD}[*] Real-Time System Load Summary:${RESET}"
            echo -e "${CYAN}--------------------------------------${RESET}"
            echo -e "${YELLOW}CPU Architecture:${RESET} $(uname -m)"
            echo -e "${YELLOW}System Uptime:${RESET} $(uptime -p)"
            echo -e "${YELLOW}Memory Breakdown:${RESET}" && free -h
            echo -e "${YELLOW}Disk Storage Allocation:${RESET}" && df -h / | grep -v Filesystem
            ;;
        9)
            echo -e "\n${BLUE}${BOLD}[*] Generating backup archive of operational configurations...${RESET}"
            mkdir -p /backup
            tar -czf /backup/skelarhub_home_backup_$(date +%F).tar.gz /home 2>/dev/null
            echo -e "${GREEN}${BOLD}[✔] Compressed archive generated successfully under /backup directory.${RESET}"
            ;;
        10)
            echo -e "\n\033[38;5;129m${BOLD}Exiting SkelarHub. Keep building!${RESET}\n"
            exit 0
            ;;
        *) echo -e "\n${RED}${BOLD}[!] Invalid Selection.${RESET} Select an option 1 through 10." ;;
    esac

    echo -e "\n${CYAN}Press [ENTER] to return to the SkelarHub Menu...${RESET}"
    read -r < /dev/tty
done
EOF
