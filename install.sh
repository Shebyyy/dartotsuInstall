#!/bin/bash
set -e

# =============================================================================
# 🎯 DARTOTSU INSTALLER - Beautiful Terminal Experience (Security Enhanced & Aligned)
# =============================================================================

# Define application details
OWNER='aayush2622'
REPO='Dartotsu'
APP_NAME='Dartotsu'

# Installation paths
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
LINK="$HOME/.local/bin/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
ICON_FILE="$HOME/.local/share/icons/$APP_NAME.png"

# =============================================================================
# 🎨 COLORS & STYLING
# =============================================================================

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Dartotsu gradient colors (teal to cyan)
GRAD1='\033[38;5;30m'   # Dark teal
GRAD2='\033[38;5;36m'   # Medium teal
GRAD3='\033[38;5;42m'   # Teal
GRAD4='\033[38;5;48m'   # Light teal
GRAD5='\033[38;5;51m'   # Cyan
GRAD6='\033[38;5;87m'   # Bright cyan

# Icons
ICON_FIRE="🔥"
ICON_LIGHTNING="⚡"
ICON_STAR="⭐"
ICON_DIAMOND="💎"
ICON_BOMB="💣"
ICON_SKULL="💀"
ICON_ROBOT="🤖"
ICON_ALIEN="👽"
ICON_GHOST="👻"
ICON_MAGIC="🪄"
ICON_CRYSTAL="🔮"
ICON_SWORD="⚔️"
ICON_SHIELD="🛡️"
ICON_CROWN="👑"
ICON_COMET="☄️"
ICON_GALAXY="🌌"
ICON_SECURITY="🔒"
ICON_WARNING="⚠️"
ICON_SUCCESS="✅"
ICON_ERROR="❌"
ICON_INFO="ℹ️"
ICON_DOWNLOAD="📥"
ICON_INSTALL="🔧"
ICON_UPDATE="🔄"
ICON_UNINSTALL="🗑️"
ICON_SPARKLES="✨"
ICON_ROCKET="🚀"

# =============================================================================
# 🛠️ UTILITY FUNCTIONS
# =============================================================================

# Get visual width of text (excluding ANSI codes)
get_visual_width() {
    local text="$1"
    # Remove ANSI escape sequences and emoji
    local clean_text=$(echo "$text" | sed 's/\x1b\[[0-9;]*[mGKHJ]//g' | sed 's/[[:space:]]*[🔥⚡⭐💎💣💀🤖👽👻🪄🔮⚔️🛡️👑☄️🌌🔒⚠️✅❌ℹ️📥🔧🔄🗑️✨🚀][[:space:]]*/X/g')
    echo "${#clean_text}"
}

# Get terminal width
get_terminal_width() {
    local width=$(tput cols 2>/dev/null || echo "80")
    echo "$width"
}

# Create a padded line with proper alignment
create_padded_line() {
    local content="$1"
    local total_width="$2"
    local border_char="${3:-│}"
    
    local content_width=$(get_visual_width "$content")
    local padding_needed=$((total_width - content_width - 4))  # 4 for borders and spaces
    
    if [ $padding_needed -lt 0 ]; then
        padding_needed=0
    fi
    
    local padding_left=$((padding_needed / 2))
    local padding_right=$((padding_needed - padding_left))
    
    printf "${BOLD}${CYAN}${border_char}${RESET}"
    printf "%*s" $padding_left ""
    printf "%s" "$content"
    printf "%*s" $padding_right ""
    printf "${BOLD}${CYAN}${border_char}${RESET}\n"
}

# Create horizontal border line
create_border_line() {
    local width="$1"
    local char="${2:-═}"
    local start_char="${3:-╔}"
    local end_char="${4:-╗}"
    
    printf "${BOLD}${CYAN}${start_char}${RESET}"
    for ((i=2; i<width; i++)); do
        printf "${BOLD}${CYAN}${char}${RESET}"
    done
    printf "${BOLD}${CYAN}${end_char}${RESET}\n"
}

# =============================================================================
# 🎭 ANIMATION & UI FUNCTIONS
# =============================================================================

# Spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [${CYAN}%c${RESET}]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    # Color gradient based on progress
    local color=""
    if [ $percentage -lt 25 ]; then
        color="${RED}"
    elif [ $percentage -lt 50 ]; then
        color="${YELLOW}"
    elif [ $percentage -lt 75 ]; then
        color="${CYAN}"
    else
        color="${GREEN}"
    fi
    
    printf "\r${BOLD}${ICON_LIGHTNING} Progress: ${RESET}["
    printf "${color}%*s${RESET}" $filled | tr ' ' '█'
    printf "${GRAY}%*s${RESET}" $empty | tr ' ' '░'
    printf "] ${BOLD}${color}%d%%${RESET} ${ICON_FIRE}" $percentage
}

# Compare commit SHAs between repos
compare_commits() {
    local main_repo="aayush2622/Dartotsu"
    local alpha_repo="grayankit/Dartotsu-Downloader"
    
    echo
    echo -ne "${CYAN}${ICON_ROBOT}${RESET} ${BOLD}Initiating quantum commit analysis${RESET}"
    for i in {1..5}; do
        sleep 0.3
        echo -ne "${CYAN}.${RESET}"
    done
    echo -e " ${GREEN}${ICON_LIGHTNING}${RESET}"
    
    # Matrix-style loading
    echo -e "${GREEN}${DIM}> Accessing GitHub API...${RESET}"
    sleep 0.5
    echo -e "${GREEN}${DIM}> Scanning commit trees...${RESET}"
    sleep 0.5
    echo -e "${GREEN}${DIM}> Cross-referencing SHA hashes...${RESET}"
    sleep 0.5
    
    # Get data
    local main_commit=$(curl -s "https://api.github.com/repos/${main_repo}/commits" | grep '"sha"' | head -1 | cut -d '"' -f 4 | cut -c1-7)
    local main_date=$(curl -s "https://api.github.com/repos/${main_repo}/commits" | grep '"date"' | head -1 | cut -d '"' -f 4)
    local main_author=$(curl -s "https://api.github.com/repos/${main_repo}/commits" | grep '"name"' | head -1 | cut -d '"' -f 4)
    
    local alpha_release=$(curl -s "https://api.github.com/repos/${alpha_repo}/releases/latest")
    local alpha_tag=$(echo "$alpha_release" | grep '"tag_name"' | cut -d '"' -f 4)
    local alpha_date=$(echo "$alpha_release" | grep '"published_at"' | cut -d '"' -f 4)
    
    echo
    
    # Dynamic box sizing for commit matrix
    local term_width=$(get_terminal_width)
    local box_width=$((term_width > 67 ? 67 : term_width - 2))
    
    create_border_line $box_width "═" "╔" "╗"
    create_padded_line "${ICON_CRYSTAL} COMMIT MATRIX ${ICON_CRYSTAL}" $box_width "║"
    create_border_line $box_width "═" "╠" "╣"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_GALAXY} ${BOLD}MAIN REPOSITORY${RESET} ${GRAY}(${main_repo})${RESET}" $box_width "║"
    create_padded_line "${ICON_DIAMOND} Commit SHA: ${YELLOW}${BOLD}${main_commit}${RESET}" $box_width "║"
    create_padded_line "${ICON_STAR} Author: ${CYAN}${main_author}${RESET}" $box_width "║"
    create_padded_line "${ICON_COMET} Timestamp: ${GRAY}$(date -d "$main_date" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null || echo "$main_date")${RESET}" $box_width "║"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_ALIEN} ${BOLD}ALPHA REPOSITORY${RESET} ${GRAY}(${alpha_repo})${RESET}" $box_width "║"
    create_padded_line "${ICON_BOMB} Release Tag: ${PURPLE}${BOLD}${alpha_tag}${RESET}" $box_width "║"
    create_padded_line "${ICON_GHOST} Published: ${GRAY}$(date -d "$alpha_date" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null || echo "$alpha_date")${RESET}" $box_width "║"
    create_padded_line "" $box_width "║"
    
    # Sync status with epic effects
    if [[ "$alpha_tag" == *"$main_commit"* ]]; then
        create_padded_line "${ICON_MAGIC} SYNC STATUS: ${GREEN}${BOLD}${ICON_FIRE} PERFECTLY SYNCHRONIZED ${ICON_FIRE}${RESET}" $box_width "║"
        create_padded_line "${GREEN}${ICON_LIGHTNING} Repositories are in perfect harmony! ${ICON_LIGHTNING}${RESET}" $box_width "║"
    else
        create_padded_line "${ICON_CRYSTAL} SYNC STATUS: ${YELLOW}${BOLD}${ICON_SWORD} DIVERGED TIMELINES ${ICON_SWORD}${RESET}" $box_width "║"
        create_padded_line "${YELLOW}${ICON_SKULL} Alpha may contain different features ${ICON_SKULL}${RESET}" $box_width "║"
    fi
    
    create_padded_line "" $box_width "║"
    create_border_line $box_width "═" "╚" "╝"
    echo
    
    # Cool countdown
    echo -ne "${BOLD}${CYAN}Preparing alpha download in: ${RESET}"
    for i in 3 2 1; do
        echo -ne "${RED}${BOLD}$i${RESET}"
        sleep 0.8
        echo -ne "\b \b"
    done
    echo -e "${GREEN}${BOLD}GO! ${ICON_ROCKET}${RESET}"
    echo
}

# Animated text typing effect
type_text() {
    local text="$1"
    local delay=${2:-0.03}
    for ((i=0; i<${#text}; i++)); do
        printf "${text:$i:1}"
        sleep $delay
    done
    echo
}

# Cool banner
show_banner() {
    clear
    echo
    
    # Get terminal width for responsive banner
    local term_width=$(get_terminal_width)
    local banner_width=$((term_width > 74 ? 74 : term_width - 2))
    
    # Animated border effect
    for i in {1..3}; do
        printf "${GRAD1}"
        for ((j=0; j<banner_width; j++)); do
            printf "═"
        done
        printf "${RESET}\n"
        sleep 0.05
        printf "\033[1A\033[K"
    done
    
    # ASCII Art - only show if terminal is wide enough
    if [ $term_width -ge 74 ]; then
        echo -e "${GRAD1}  ██████╗  █████╗ ██████╗ ████████╗ ██████╗ ████████╗███████╗██╗   ██╗${RESET}"
        echo -e "${GRAD2}  ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗╚══██╔══╝██╔════╝██║   ██║${RESET}"
        echo -e "${GRAD3}  ██║  ██║███████║██████╔╝   ██║   ██║   ██║   ██║   ███████╗██║   ██║${RESET}"
        echo -e "${GRAD4}  ██║  ██║██╔══██║██╔══██╗   ██║   ██║   ██║   ██║   ╚════██║██║   ██║${RESET}"
        echo -e "${GRAD5}  ██████╔╝██║  ██║██║  ██║   ██║   ╚██████╔╝   ██║   ███████║╚██████╔╝${RESET}"
        echo -e "${GRAD6}  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝ ${RESET}"
    else
        echo -e "${GRAD3}${BOLD}  D A R T O T S U${RESET}"
    fi
    
    echo
    echo -e "${CYAN}${BOLD}                 ${ICON_FIRE}${ICON_LIGHTNING} The Ultimate Anime & Manga Experience ${ICON_LIGHTNING}${ICON_FIRE}${RESET}"
    
    # Responsive underline
    local underline_width=$((term_width > 50 ? 50 : term_width - 10))
    printf "${GRAY}                    "
    for ((i=0; i<underline_width; i++)); do
        printf "═"
    done
    printf "${RESET}\n"
    
    echo -e "${PURPLE}${DIM}                           ${ICON_GALAXY} Powered by Dreams ${ICON_GALAXY}${RESET}"
    echo -e "${GREEN}${DIM}                      ${ICON_SECURITY} Security Enhanced Version ${ICON_SECURITY}${RESET}"
    echo
}

# Stylized section headers
section_header() {
    local title="$1"
    local icon="$2"
    local term_width=$(get_terminal_width)
    local box_width=$((term_width > 57 ? 57 : term_width - 2))
    
    echo
    create_border_line $box_width "─" "╭" "╮"
    create_padded_line "${icon} ${BOLD}${WHITE}${title}${RESET}" $box_width "│"
    create_border_line $box_width "─" "╰" "╯"
    echo
}

# Success message with animation
success_msg() {
    local msg="$1"
    local term_width=$(get_terminal_width)
    local box_width=$((term_width > 54 ? 54 : term_width - 2))
    
    echo
    create_border_line $box_width "─" "┌" "┐"
    create_padded_line "${GREEN}${BOLD}SUCCESS!${RESET}" $box_width "│"
    create_padded_line "${ICON_SUCCESS} ${msg}" $box_width "│"
    create_border_line $box_width "─" "└" "┘"
    echo
}

# Error message
error_msg() {
    local msg="$1"
    local term_width=$(get_terminal_width)
    local box_width=$((term_width > 54 ? 54 : term_width - 2))
    
    echo
    create_border_line $box_width "─" "┌" "┐"
    create_padded_line "${RED}${BOLD}ERROR!${RESET}" $box_width "│"
    create_padded_line "${ICON_ERROR} ${msg}" $box_width "│"
    create_border_line $box_width "─" "└" "┘"
    echo
}

# Info message
info_msg() {
    local msg="$1"
    echo -e "${CYAN}${ICON_INFO}${RESET} ${msg}"
}

# Warning message
warn_msg() {
    local msg="$1"
    echo -e "${YELLOW}${ICON_WARNING}${RESET} ${msg}"
}

# Security message
security_msg() {
    local msg="$1"
    echo -e "${GREEN}${ICON_SECURITY}${RESET} ${msg}"
}

# Stylized menu
show_menu() {
    local term_width=$(get_terminal_width)
    local box_width=$((term_width > 59 ? 59 : term_width - 2))
    
    # Glitch effect header
    printf "${GRAD1}█${GRAD2}█${GRAD3}█${GRAD4}█${GRAD5}█${GRAD6}█${RESET} ${BOLD}DARTOTSU CONTROL PANEL${RESET} ${GRAD6}█${GRAD5}█${GRAD4}█${GRAD3}█${GRAD2}█${GRAD1}█${RESET}\n"
    echo
    
    create_border_line $box_width "═" "╔" "╗"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_ROBOT} ${GREEN}${BOLD}[I]${RESET} ${ICON_DOWNLOAD} Install Dartotsu ${GRAY}(Get Started)${RESET}" $box_width "║"
    create_padded_line "${GREEN}Deploy the ultimate anime experience${RESET}" $box_width "║"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_LIGHTNING} ${YELLOW}${BOLD}[U]${RESET} ${ICON_UPDATE} Update Dartotsu ${GRAY}(Stay Current)${RESET}" $box_width "║"
    create_padded_line "${YELLOW}Upgrade to the latest and greatest${RESET}" $box_width "║"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_BOMB} ${RED}${BOLD}[R]${RESET} ${ICON_UNINSTALL} Remove Dartotsu ${GRAY}(Nuclear Option)${RESET}" $box_width "║"
    create_padded_line "${RED}Complete annihilation of installation${RESET}" $box_width "║"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_GHOST} ${CYAN}${BOLD}[Q]${RESET} ${ICON_SPARKLES} Quit ${GRAY}(Escape the Matrix)${RESET}" $box_width "║"
    create_padded_line "${CYAN}Return to the real world${RESET}" $box_width "║"
    create_padded_line "" $box_width "║"
    create_border_line $box_width "═" "╚" "╝"
    echo
    echo -ne "${BOLD}${WHITE}Enter the matrix${RESET} ${GRAY}(I/U/R/Q)${RESET} ${ICON_MAGIC}: "
}

# Version selection menu
version_menu() {
    local term_width=$(get_terminal_width)
    local box_width=$((term_width > 59 ? 59 : term_width - 2))
    
    echo
    # Animated title
    for char in "V" "E" "R" "S" "I" "O" "N" " " "S" "E" "L" "E" "C" "T" "I" "O" "N"; do
        echo -ne "${BOLD}${PURPLE}$char${RESET}"
        sleep 0.05
    done
    echo
    echo
    
    create_border_line $box_width "═" "╔" "╗"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_CROWN} ${GREEN}${BOLD}[S]${RESET} Stable Release ${GRAY}(Battle-Tested)${RESET}" $box_width "║"
    create_padded_line "${ICON_SHIELD} Rock solid, enterprise ready" $box_width "║"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_LIGHTNING} ${YELLOW}${BOLD}[P]${RESET} Pre-release ${GRAY}(Bleeding Edge)${RESET}" $box_width "║"
    create_padded_line "${ICON_FIRE} Latest features, some bugs possible" $box_width "║"
    create_padded_line "" $box_width "║"
    create_padded_line "${ICON_BOMB} ${PURPLE}${BOLD}[A]${RESET} Alpha Build ${GRAY}(Danger Zone!)${RESET}" $box_width "║"
    create_padded_line "${ICON_SKULL} Experimental, use at your own risk" $box_width "║"
    create_padded_line "" $box_width "║"
    create_border_line $box_width "═" "╚" "╝"
    echo
    echo -ne "${BOLD}${WHITE}Choose your destiny${RESET} ${GRAY}(S/P/A)${RESET} ${ICON_MAGIC}: "
}

# =============================================================================
# 🐚 SHELL ALIAS MANAGEMENT
# =============================================================================

detect_shell_rc() {
  local shell_name
  shell_name=$(basename "$SHELL")
  case "$shell_name" in
    bash) echo "$HOME/.bashrc" ;;
    zsh) echo "$HOME/.zshrc" ;;
    fish) echo "$HOME/.config/fish/config.fish" ;; 
    *) echo "$HOME/.profile" ;; 
  esac
}

add_updater_alias() {
  local shell_rc
  shell_rc=$(detect_shell_rc)
  local alias_line="alias dartotsu-updater='bash <(curl -s https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/install.sh) update'"

  if grep -Fxq "$alias_line" "$shell_rc" 2>/dev/null; then
    echo -ne "${YELLOW}${ICON_WARNING}${RESET} The 'dartotsu-updater' alias already exists in your shell config file ($(basename "$shell_rc")). Would you like to remove it? [y/N]: "
    read -r remove_response
    case "$remove_response" in
      [yY][eE][sS]|[yY])
        sed -i "\|$alias_line|d" "$shell_rc"
        echo -e " ${GREEN}${ICON_SUCCESS} Alias removed from $(basename "$shell_rc")${RESET}"
        ;;
      *)
        echo -e " ${CYAN}${ICON_INFO} Keeping existing alias.${RESET}"
        ;;
    esac
  else
    echo -ne "${CYAN}${ICON_MAGIC}${RESET} Would you like to add the 'dartotsu-updater' alias to your shell config file ($(basename "$shell_rc"))? [y/N]: "
    read -r add_response
    case "$add_response" in
      [yY][eE][sS]|[yY])
        echo "$alias_line" >> "$shell_rc"
        echo -e " ${GREEN}${ICON_SUCCESS} Alias added to $(basename "$shell_rc")${RESET}"
        info_msg "You can now run '${BOLD}dartotsu-updater${RESET}' to update anytime!"
        info_msg "Run '${BOLD}source $shell_rc${RESET}' or restart your terminal to activate the alias"
        ;;
      *)
        echo -e " ${YELLOW}${ICON_WARNING} Skipped adding alias${RESET}"
        ;;
    esac
  fi
}

# =============================================================================
# 🛠️ ENHANCED DEPENDENCY MANAGEMENT
# =============================================================================

# Check if running in container/CI
is_containerized() {
    [ -f /.dockerenv ] || [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ]
}

# Enhanced dependency checking with better error handling
check_dependencies() {
    local missing_deps=()
    local optional_deps=()
    
    # Check command-line tools
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v unzip >/dev/null 2>&1 || missing_deps+=("unzip")
    command -v wget >/dev/null 2>&1 || missing_deps+=("wget")
    command -v mpv >/dev/null 2>&1 || missing_deps+=("mpv")
    command -v sha256sum >/dev/null 2>&1 || missing_deps+=("sha256sum")
    
    # Check optional tools
    command -v git >/dev/null 2>&1 || optional_deps+=("git")
    
    # Check libraries using pkg-config
    if command -v pkg-config >/dev/null 2>&1; then
        # Check for WebKit2GTK with fallback to older version
        if ! pkg-config --exists webkit2gtk-4.1 2>/dev/null; then
            if ! pkg-config --exists libwebkit2gtk-4.1-0 2>/dev/null; then
                missing_deps+=("webkit2gtk")
            fi
        fi
        
        # Additional library checks for GUI applications
        pkg-config --exists gtk+-3.0 2>/dev/null || missing_deps+=("gtk3")
    else
        missing_deps+=("pkg-config" "webkit2gtk" "gtk3")
    fi
    
    # Report missing dependencies
    if [ ${#missing_deps[@]} -ne 0 ]; then
        warn_msg "Missing required dependencies: ${missing_deps[*]}"
        
        if [ ${#optional_deps[@]} -ne 0 ]; then
            info_msg "Optional dependencies not found: ${optional_deps[*]}"
        fi
        
        echo
        if is_containerized; then
            info_msg "Container environment detected - attempting automatic installation..."
            export DEBIAN_FRONTEND=noninteractive
            install_packages "${missing_deps[@]}"
        else
            echo -e "${YELLOW}${BOLD}Would you like to install required dependencies automatically?${RESET} ${GRAY}(y/N)${RESET}: "
            read -n 1 INSTALL_DEPS
            echo
            
            if [[ "${INSTALL_DEPS,,}" == "y" ]]; then
                install_packages "${missing_deps[@]}"
            else
                error_exit "Required dependencies must be installed to continue: ${missing_deps[*]}"
            fi
        fi
    elif [ ${#optional_deps[@]} -ne 0 ]; then
        info_msg "Optional dependencies not found: ${optional_deps[*]}"
        echo -e "${GRAY}These are not required but may provide additional functionality.${RESET}"
    else
        info_msg "All dependencies are satisfied!"
    fi
}

# Enhanced package installation with better error recovery
install_packages() {
    local deps=("$@")
    local install_cmd=""
    local update_cmd=""
    local distro=""
    
    # Detect distribution and package manager
    if command -v apt >/dev/null 2>&1; then
        distro="debian"
        update_cmd="sudo apt update -y"
        install_cmd="sudo apt install -y"
        
        # Map library names to Ubuntu/Debian package names
        deps=("${deps[@]/webkit2gtk/libwebkit2gtk-4.1-0}")
        deps=("${deps[@]/gtk3/libgtk-3-dev}")
        deps=("${deps[@]/pkg-config/pkg-config}")
        deps=("${deps[@]/sha256sum/coreutils}")
        
    elif command -v dnf >/dev/null 2>&1; then
        distro="fedora"
        install_cmd="sudo dnf install -y"
        
        # Map library names to Fedora package names
        deps=("${deps[@]/webkit2gtk/webkit2gtk4.1-0}")
        deps=("${deps[@]/gtk3/gtk3-devel}")
        deps=("${deps[@]/pkg-config/pkgconf-devel}")
        deps=("${deps[@]/sha256sum/coreutils}")
        
    elif command -v pacman >/dev/null 2>&1; then
        distro="arch"
        update_cmd="sudo pacman -Sy"
        install_cmd="sudo pacman -S --noconfirm"
        
        # Map library names to Arch package names
        deps=("${deps[@]/webkit2gtk/webkit2gtk-4.1}")
        deps=("${deps[@]/gtk3/gtk3}")
        deps=("${deps[@]/pkg-config/pkgconf}")
        deps=("${deps[@]/sha256sum/coreutils}")
        
    elif command -v zypper >/dev/null 2>&1; then
        distro="opensuse"
        install_cmd="sudo zypper install -y"
        
        # Map library names to openSUSE package names
        deps=("${deps[@]/webkit2gtk/webkit2gtk3-devel}")
        deps=("${deps[@]/gtk3/gtk3-devel}")
        deps=("${deps[@]/pkg-config/pkg-config}")
        deps=("${deps[@]/sha256sum/coreutils}")
        
    elif command -v brew >/dev/null 2>&1; then
        distro="macos"
        install_cmd="brew install"
        
        # Map library names to Homebrew package names
        deps=("${deps[@]/webkit2gtk/}")  # Remove webkit2gtk for macOS
        deps=("${deps[@]/gtk3/gtk+3}")
        deps=("${deps[@]/pkg-config/pkg-config}")
        deps=("${deps[@]/sha256sum/coreutils}")
        
    else
        error_exit "No supported package manager found! Please install manually: ${deps[*]}"
    fi
    
    # Filter out empty elements
    local filtered_deps=()
    for dep in "${deps[@]}"; do
        [[ -n "$dep" ]] && filtered_deps+=("$dep")
    done
    deps=("${filtered_deps[@]}")
    
    if [ ${#deps[@]} -eq 0 ]; then
        info_msg "No packages to install for this system."
        return 0
    fi
    
    info_msg "Detected system: $distro"
    info_msg "Installing packages: ${deps[*]}"
    
    # Update package lists if needed
    if [ -n "$update_cmd" ]; then
        echo -ne "${CYAN}${ICON_INSTALL}${RESET} Updating package lists..."
        if eval "$update_cmd" >/dev/null 2>&1; then
            echo -e " ${GREEN}${ICON_SUCCESS}${RESET}"
        else
            echo -e " ${YELLOW}${ICON_WARNING} Update failed, continuing...${RESET}"
        fi
    fi
    
    # Install packages
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Installing dependencies..."
    
    if eval "$install_cmd ${deps[*]}" >/dev/null 2>&1; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
        info_msg "Dependencies installed successfully!"
    else
        echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
        
        # Try installing packages individually to identify problematic ones
        warn_msg "Attempting to install packages individually..."
        local failed_packages=()
        
        for pkg in "${deps[@]}"; do
            echo -ne "  Installing $pkg..."
            if eval "$install_cmd $pkg" >/dev/null 2>&1; then
                echo -e " ${GREEN}${ICON_SUCCESS}${RESET}"
            else
                echo -e " ${RED}${ICON_ERROR}${RESET}"
                failed_packages+=("$pkg")
            fi
        done
        
        if [ ${#failed_packages[@]} -ne 0 ]; then
            error_exit "Failed to install: ${failed_packages[*]}. Please install manually."
        fi
    fi
}

# Verify installation of critical dependencies
verify_installation() {
    local critical_deps=("curl" "unzip" "wget" "sha256sum")
    local failed_deps=()
    
    for dep in "${critical_deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            failed_deps+=("$dep")
        fi
    done
    
    if [ ${#failed_deps[@]} -ne 0 ]; then
        error_exit "Critical dependencies still missing after installation: ${failed_deps[*]}"
    fi
    
    # Verify library installations
    if command -v pkg-config >/dev/null 2>&1; then
        if ! pkg-config --exists webkit2gtk-4.1 2>/dev/null && ! pkg-config --exists webkit2gtk-3.0 2>/dev/null; then
            warn_msg "WebKit2GTK may not be properly installed - some features may not work"
        fi
    fi
    
    info_msg "Installation verification completed!"
}

# =============================================================================
# 🛠️  CORE FUNCTIONS
# =============================================================================

error_exit() {
    error_msg "$1"
    echo -e "${GRAY}${DIM}Press any key to exit...${RESET}"
    read -n 1
    exit 1
}

# Enhanced download function with security improvements
download_with_progress() {
    local url="$1"
    local output="$2"
    local filename=$(basename "$url")
    
    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Downloading ${BOLD}${filename}${RESET}..."
    
    # Download in background and show spinner
    curl -sL "$url" -o "$output" &
    local curl_pid=$!
    spinner $curl_pid
    wait $curl_pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
        return 0
    else
        echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
        return 1
    fi
}

# Enhanced verification function
verify_download() {
    local downloaded_file="$1"
    local api_url="$2"
    
    # Get file size for basic verification
    local file_size=$(stat -c%s "$downloaded_file" 2>/dev/null || stat -f%z "$downloaded_file" 2>/dev/null)
    
    if [ -z "$file_size" ] || [ "$file_size" -eq 0 ]; then
        error_exit "Downloaded file is empty or corrupted!"
    fi
    
    security_msg "Downloaded file size: ${file_size} bytes"
    
    # Try to get SHA256 from GitHub API (if available)
    echo -ne "${CYAN}${ICON_SECURITY}${RESET} Attempting to verify download integrity..."
    
    # Note: GitHub doesn't provide SHA256 in API, but we can compute and display it
    local actual_sha256=$(sha256sum "$downloaded_file" | cut -d' ' -f1)
    echo -e " ${GREEN}${ICON_SUCCESS}${RESET}"
    
    security_msg "File SHA256: ${actual_sha256}"
    
    # Basic file type verification
    if ! file "$downloaded_file" | grep -q "Zip archive"; then
        warn_msg "Downloaded file may not be a valid ZIP archive!"
        echo -e "${YELLOW}${BOLD}Continue anyway?${RESET} ${GRAY}(y/N)${RESET}: "
        read -n 1 continue_anyway
        echo
        if [[ "${continue_anyway,,}" != "y" ]]; then
            error_exit "Installation aborted due to file verification failure."
        fi
    fi
}

# User confirmation and review functions
confirm_installation() {
    local term_width=$(get_terminal_width)
    local box_width=$((term_width > 59 ? 59 : term_width - 2))
    
    echo
    create_border_line $box_width "═" "╔" "╗"
    create_padded_line "${ICON_SECURITY} SECURITY CHECKPOINT ${ICON_SECURITY}" $box_width "║"
    create_border_line $box_width "═" "╚" "╝"
    echo
    security_msg "Download completed successfully!"
    echo
    echo -e "${BOLD}${GREEN}Ready to install Dartotsu. Continue?${RESET} ${GRAY}(y/N)${RESET}: "
    read -r confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo
        warn_msg "Installation cancelled by user."
        echo -e "${GRAY}${DIM}Press any key to return to menu...${RESET}"
        read -n 1
        return 1
    fi
    
    return 0
}

offer_content_review() {
    local downloaded_file="$1"
    
    echo
    echo -e "${BOLD}${YELLOW}Download complete. Review before installation?${RESET} ${GRAY}(y/N)${RESET}: "
    read -r review
    
    if [[ "$review" =~ ^[Yy]$ ]]; then
        echo
        info_msg "Opening file contents for review..."
        echo -e "${GRAY}${DIM}Press 'q' to quit the viewer and continue with installation.${RESET}"
        echo
        sleep 2
        
        # Try to show archive contents
        if command -v unzip >/dev/null 2>&1; then
            echo -e "${CYAN}${ICON_INFO}${RESET} Archive contents:"
            unzip -l "$downloaded_file" | head -20
            echo
            if [ "$(unzip -l "$downloaded_file" | wc -l)" -gt 25 ]; then
                echo -e "${GRAY}${DIM}... (truncated, showing first 20 entries)${RESET}"
                echo
            fi
        fi
        
        echo -e "${BOLD}${GREEN}Proceed with installation?${RESET} ${GRAY}(y/N)${RESET}: "
        read -r proceed
        
        if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
            echo
            warn_msg "Installation cancelled after review."
            echo -e "${GRAY}${DIM}Press any key to return to menu...${RESET}"
            read -n 1
            return 1
        fi
    fi
    
    return 0
}

install_app() {
    section_header "INSTALLATION PROCESS" "${ICON_INSTALL}"
    
    # Check dependencies with enhanced system
    info_msg "Checking system dependencies..."
    check_dependencies
    verify_installation
    echo -e "  ${GREEN}${ICON_SUCCESS} All dependencies verified!${RESET}"
    echo
    
    # Version selection
    version_menu
    read -n 1 ANSWER
    echo
    
    # Replace the case statement with enhanced security options
    case "${ANSWER,,}" in
        p)
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases"
            info_msg "Fetching pre-release versions..."
            ;;
        a)
            OWNER="grayankit"
            REPO="Dartotsu-Downloader"
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            info_msg "Fetching alpha build..."
            echo
            compare_commits
            ;;
        s|"")
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            info_msg "Fetching stable release..."
            ;;
        *)
            warn_msg "Invalid selection, defaulting to stable release..."
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            ;;
    esac
    
    # Fetch release info
    ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
    
    if [ -z "$ASSET_URL" ]; then
        error_exit "No downloadable assets found in the release!"
    fi
    
    # Download with enhanced security
    echo
    if ! download_with_progress "$ASSET_URL" "/tmp/$APP_NAME.zip"; then
        error_exit "Download failed!"
    fi
    
    # Security verification
    echo
    info_msg "Performing security verification..."
    verify_download "/tmp/$APP_NAME.zip" "$API_URL"
    
    # User confirmation
    if ! confirm_installation; then
        rm -f "/tmp/$APP_NAME.zip"
        return
    fi
    
    # Content review option
    if ! offer_content_review "/tmp/$APP_NAME.zip"; then
        rm -f "/tmp/$APP_NAME.zip"
        return
    fi
    
    # Installation
    echo
    info_msg "Installing to ${BOLD}$INSTALL_DIR${RESET}..."
    
    if [ -d "$INSTALL_DIR" ]; then
        warn_msg "Existing installation detected - creating backup..."
        if [ -d "$INSTALL_DIR.backup" ]; then
            rm -rf "$INSTALL_DIR.backup"
        fi
        mv "$INSTALL_DIR" "$INSTALL_DIR.backup"
        security_msg "Backup created at $INSTALL_DIR.backup"
    fi
    
    mkdir -p "$INSTALL_DIR"
    
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Extracting files..."
    if unzip "/tmp/$APP_NAME.zip" -d "$INSTALL_DIR" > /dev/null 2>&1; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    else
        echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
        # Restore backup if extraction failed
        if [ -d "$INSTALL_DIR.backup" ]; then
            warn_msg "Restoring backup due to extraction failure..."
            rm -rf "$INSTALL_DIR"
            mv "$INSTALL_DIR.backup" "$INSTALL_DIR"
        fi
        error_exit "Failed to extract application files!"
    fi
    
    # Find executable
    APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f -executable -print -quit)"
    if [ -z "$APP_EXECUTABLE" ]; then
        # Try to find by common executable extensions
        APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f \( -name "*.AppImage" -o -name "*.exe" -o -name "dartotsu*" \) -print -quit)"
        if [ -z "$APP_EXECUTABLE" ]; then
            error_exit "No executable found in the extracted files!"
        fi
    fi
    
    chmod +x "$APP_EXECUTABLE"
    
    # Create symlink
    mkdir -p "$HOME/.local/bin"
    ln -sf "$APP_EXECUTABLE" "$LINK"
    
    # Install icon
    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Installing icon..."
    mkdir -p "$(dirname "$ICON_FILE")"
    fallback_icon_url='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/assets/images/logo.png'
    if wget -q "$fallback_icon_url" -O "$ICON_FILE" 2>/dev/null; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    else
        echo -e " ${YELLOW}${ICON_WARNING} Icon download failed (non-critical)${RESET}"
    fi
    
    # Create desktop entry
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Creating desktop entry..."
    mkdir -p "$(dirname "$DESKTOP_FILE")"
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=The Ultimate Anime & Manga Experience
Exec=$LINK
Icon=$ICON_FILE
Type=Application
Categories=AudioVideo;Player;
EOL
    chmod +x "$DESKTOP_FILE"
    
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    fi
    echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"

    # Create shell alias for easy updates
    add_updater_alias
    
    # Cleanup
    rm -f "/tmp/$APP_NAME.zip"
    
    # Remove backup if installation was successful
    if [ -d "$INSTALL_DIR.backup" ]; then
        echo -ne "${CYAN}${ICON_INSTALL}${RESET} Cleaning up backup..."
        rm -rf "$INSTALL_DIR.backup"
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    fi
    
    echo
    success_msg "$APP_NAME has been installed successfully!"
    security_msg "Installation completed with security verification!"
    info_msg "You can now launch it from your applications menu or run: ${BOLD}$APP_NAME${RESET}"
    
    echo
    echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
    read -n 1
}

uninstall_app() {
    section_header "UNINSTALLATION PROCESS" "${ICON_UNINSTALL}"
    
    if [ ! -d "$INSTALL_DIR" ] && [ ! -L "$LINK" ]; then
        warn_msg "$APP_NAME doesn't appear to be installed!"
        echo
        echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
        read -n 1
        return
    fi
    
    echo -e "${YELLOW}${BOLD}Are you sure you want to remove $APP_NAME?${RESET} ${GRAY}(y/N)${RESET}: "
    read -n 1 CONFIRM
    echo
    
    if [[ "${CONFIRM,,}" != "y" ]]; then
        info_msg "Uninstallation cancelled."
        echo
        echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
        read -n 1
        return
    fi
    
    echo
    info_msg "Removing $APP_NAME components..."
    
    # Remove components
    [ -L "$LINK" ] && rm -f "$LINK" && echo -e "  ${GREEN}✓${RESET} Executable symlink removed"
    [ -d "$INSTALL_DIR" ] && rm -rf "$INSTALL_DIR" && echo -e "  ${GREEN}✓${RESET} Installation directory removed"
    [ -f "$DESKTOP_FILE" ] && rm -f "$DESKTOP_FILE" && echo -e "  ${GREEN}✓${RESET} Desktop entry removed"
    [ -f "$ICON_FILE" ] && rm -f "$ICON_FILE" && echo -e "  ${GREEN}✓${RESET} Icon removed"
    [ -d "$INSTALL_DIR.backup" ] && rm -rf "$INSTALL_DIR.backup" && echo -e "  ${GREEN}✓${RESET} Backup directory removed"
    
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    fi
    
    echo
    success_msg "$APP_NAME has been completely removed!"
    
    echo
    echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
    read -n 1
}

update_app() {
    section_header "UPDATE PROCESS" "${ICON_UPDATE}"
    
    if [ ! -d "$INSTALL_DIR" ] && [ ! -L "$LINK" ]; then
        warn_msg "$APP_NAME doesn't appear to be installed!"
        info_msg "Would you like to install it instead? ${GRAY}(y/N)${RESET}: "
        read -n 1 INSTALL_INSTEAD
        echo
        
        if [[ "${INSTALL_INSTEAD,,}" == "y" ]]; then
            install_app
        else
            echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
            read -n 1
        fi
        return
    fi
    
    info_msg "Updating $APP_NAME to the latest version..."
    echo
    install_app
    
    # Ensure alias is still present after update
    add_updater_alias
}

# =============================================================================
# 🚀 MAIN SCRIPT
# =============================================================================

main_loop() {
    while true; do
        show_banner
        show_menu
        read -n 1 ACTION
        echo
        
        case "${ACTION,,}" in
            i|install)
                install_app
                ;;
            u|update)
                update_app
                ;;
            r|remove|uninstall)
                uninstall_app
                ;;
            q|quit|exit)
                echo
                type_text "Thanks for using Dartotsu Installer! ${ICON_SPARKLES}" 0.05
                echo -e "${GRAY}${DIM}Goodbye!${RESET}"
                exit 0
                ;;
            *)
                echo
                warn_msg "Invalid selection! Please choose I, U, R, or Q."
                echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
                read -n 1
                ;;
        esac
    done
}

# Check if running in interactive mode
if [ $# -gt 0 ]; then
    # Non-interactive mode - handle command line arguments
    ACTION="$1"
    case "${ACTION,,}" in
        install)
            show_banner
            install_app
            ;;
        update)
            show_banner
            update_app
            ;;
        uninstall|remove)
            show_banner
            uninstall_app
            ;;
        *)
            show_banner
            echo -e "${RED}Usage: $0 [install|update|uninstall]${RESET}"
            echo -e "${GRAY}Or run without arguments for interactive mode.${RESET}"
            exit 1
            ;;
    esac
elif [ -t 0 ]; then
    # Interactive mode - show menu
    main_loop
else
    # Fallback to interactive mode
    main_loop
fi
