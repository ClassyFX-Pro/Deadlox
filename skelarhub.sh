#!/bin/bash

# Define ANSI Color Codes for the Hub UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Ensure the script is run with sudo privileges
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}${BOLD}[ERROR]${RESET} Please run SkelarHub using sudo: sudo ./skelarhub.sh"
  exit 1
fi

# Detect Linux Distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi

# Helper function to display the large SkelarHub Banner
draw_header() {
    clear
    echo -e "${MAGENTA}${BOLD}"
    echo "  ██████  ██   ██ ███████ ██       █████  ██████  ██   ██ ██    ██ ██████  "
    echo " ██       ██  ██  ██      ██      ██   ██ ██   ██ ██   ██ ██    ██ ██   ██ "
    echo "  ██████  █████   █████   ██      ███████ ██████  ███████ ██    ██ ██████  "
    echo "       ██ ██  ██  ██      ██      ██   ██ ██   ██ ██   ██ ██    ██ ██   ██ "
    echo "  ██████  ██   ██ ███████ ███████ ██   ██ ██   ██ ██   ██  ██████  ██████  "
    echo -e "${RESET}"
    echo -e "${CYAN}${BOLD}========================================================================${RESET}"
    echo -e "${BLUE}${BOLD} System OS Detected:${RESET} ${YELLOW}${OS}${RESET}"
    echo -e "${CYAN}${BOLD}========================================================================${RESET}"
}

# Core package list configurations
DEB_DEV="build-essential git curl wget vim nano tmux htop python3 python3-pip nodejs npm docker.io docker-compose"
RPM_DEV="curl wget git @development-tools vim-enhanced nano htop tmux python3 python3-pip nodejs docker docker-compose"
ARCH_DEV="base-devel git curl wget vim nano tmux htop python3 python3-pip nodejs npm docker docker-compose"

# Function to automatically find and heal missing basic tools
ai_diagnostic() {
    echo -e "\n${MAGENTA}${BOLD}[AI MODE] Running system self-healing checks...${RESET}"
    
    # Core utilities to inspect
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
            ubuntu|debian|pop|mint)
                apt-get update -y && apt-get install -y "${missing[@]}" ;;
            fedora)
                dnf install -y "${missing[@]}" ;;
            centos|rhel|almalinux|rocky)
                yum install -y epel-release && yum install -y "${missing[@]}" ;;
            arch)
                pacman -Sy --needed --noconfirm "${missing[@]}" ;;
            *)
                echo -e "${RED}[ERROR] AI mode cannot patch this OS profile manually.${RESET}" ;;
        esac
        echo -e "${GREEN}${BOLD}[✔] AI Mode complete: Missing binaries resolved.${RESET}"
    fi
}

# Main Script Loop
while true; do
    draw_header
    echo -e "${GREEN}${BOLD} [1]${RESET} Update & Upgrade System Packages"
    echo -e "${GREEN}${BOLD} [2]${RESET} AI Mode (Auto-Detect & Install Missing Core Utilities)"
    echo -e "${GREEN}${BOLD} [3]${RESET} Developer Suite (Compilers, Runtimes, Git, Docker)"
    echo -e "${RED}${BOLD} [4]${RESET} Exit SkelarHub"
    echo -e "${CYAN}${BOLD}========================================================================${RESET}"
    
    echo -n -e "${YELLOW}${BOLD}Select an option [1-4]: ${RESET}"
    read -r choice

    case $choice in
        1)
            echo -e "\n${BLUE}${BOLD}[*] Commencing complete repository sync and upgrade...${RESET}"
            case "$OS" in
                ubuntu|debian|pop|mint) apt-get update -y && apt-get upgrade -y ;;
                fedora) dnf upgrade -y ;;
                centos|rhel|almalinux|rocky) yum update -y ;;
                arch) pacman -Syu --noconfirm ;;
                *) echo -e "${RED}[ERROR] Package manager not mapped for system updates.${RESET}" ;;
            esac
            ;;
        2)
            ai_diagnostic
            ;;
        3)
            echo -e "\n${BLUE}${BOLD}[*] Installing comprehensive Developer Workspace Packages...${RESET}"
            case "$OS" in
                ubuntu|debian|pop|mint)
                    apt-get update -y && apt-get install -y $DEB_DEV ;;
                fedora)
                    dnf install -y $RPM_DEV ;;
                centos|rhel|almalinux|rocky)
                    yum install -y epel-release && yum install -y $RPM_DEV ;;
                arch)
                    pacman -Sy --needed --noconfirm $ARCH_DEV ;;
                *)
                    echo -e "${RED}[ERROR] OS profile not recognized for developer bundle.${RESET}" ;;
            esac
            echo -e "${GREEN}${BOLD}[✔] Developer suite has been completely configured!${RESET}"
            ;;
        4)
            echo -e "\n${MAGENTA}${BOLD}Exiting SkelarHub. Keep building!${RESET}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}${BOLD}[!] Invalid Selection.${RESET} Please pick an option from 1 to 4."
            ;;
    esac

    echo -e "\n${CYAN}Press [ENTER] to return to the SkelarHub Menu...${RESET}"
    read -r
done
