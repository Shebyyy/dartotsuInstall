#!/bin/bash
set -e

# =============================================================================
# 🎯 ANYMEX INSTALLER - Multi-Service Anime & Manga Tracking
# =============================================================================

# Define application details
OWNER='RyanYuuki'
REPO='AnymeX'
APP_NAME='AnymeX'

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

# AnymeX gradient colors (purple to blue)
GRAD1='\033[38;5;57m'   # Dark purple
GRAD2='\033[38;5;63m'   # Medium purple
GRAD3='\033[38;5;69m'   # Light purple
GRAD4='\033[38;5;75m'   # Purple-blue
GRAD5='\033[38;5;81m'   # Light blue
GRAD6='\033[38;5;87m'   # Bright blue

# Icons
ICON_FIRE="🔥"
ICON_LIGHTNING="⚡"
ICON_STAR="⭐"
ICON_DIAMOND="💎"
ICON_BOMB="💣"
ICON_ROBOT="🤖"
ICON_GHOST="👻"
ICON_MAGIC="🪄"
ICON_CRYSTAL="🔮"
ICON_SWORD="⚔️"
ICON_SHIELD="🛡️"
ICON_CROWN="👑"
ICON_COMET="☄️"
ICON_GALAXY="🌌"

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
    for i in {1..3}; do
        echo -e "${GRAD1}════════════════════════════════════════════════════════════════════════${RESET}"
        sleep 0.05
        printf "\033[1A\033[K"
    done
    
    echo -e "${GRAD1}  █████╗ ███╗   ██╗██╗   ██╗███╗   ███╗███████╗██╗  ██╗${RESET}"
    echo -e "${GRAD2} ██╔══██╗████╗  ██║╚██╗ ██╔╝████╗ ████║██╔════╝╚██╗██╔╝${RESET}"
    echo -e "${GRAD3} ███████║██╔██╗ ██║ ╚████╔╝ ██╔████╔██║█████╗   ╚███╔╝ ${RESET}"
    echo -e "${GRAD4} ██╔══██║██║╚██╗██║  ╚██╔╝  ██║╚██╔╝██║██╔══╝   ██╔██╗ ${RESET}"
    echo -e "${GRAD5} ██║  ██║██║ ╚████║   ██║   ██║ ╚═╝ ██║███████╗██╔╝ ██╗${RESET}"
    echo -e "${GRAD6} ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝${RESET}"
    echo
    echo -e "${CYAN}${BOLD}          ${ICON_FIRE}${ICON_LIGHTNING} Multi-Service Anime & Manga Tracking ${ICON_LIGHTNING}${ICON_FIRE}${RESET}"
    echo -e "${GRAY}                    ═══════════════════════════════════════${RESET}"
    echo -e "${PURPLE}${DIM}                           ${ICON_GALAXY} Powered by Community ${ICON_GALAXY}${RESET}"
    echo
}

# Stylized section headers
section_header() {
    local title="$1"
    local icon="$2"
    echo
    echo -e "${BOLD}${BLUE}╭─────────────────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${BLUE}│${RESET} ${icon} ${BOLD}${WHITE}${title}${RESET} ${BLUE}│${RESET}"
    echo -e "${BOLD}${BLUE}╰─────────────────────────────────────────────────────╯${RESET}"
    echo
}

# Success message
success_msg() {
    local msg="$1"
    echo
    echo -e "${GREEN}${BOLD}┌─ SUCCESS! ─────────────────────────────────────────┐${RESET}"
    echo -e "${GREEN}${BOLD}│${RESET} ${ICON_STAR} ${msg} ${GREEN}${BOLD}│${RESET}"
    echo -e "${GREEN}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo
}

# Error message
error_msg() {
    local msg="$1"
    echo
    echo -e "${RED}${BOLD}┌─ ERROR! ───────────────────────────────────────────┐${RESET}"
    echo -e "${RED}${BOLD}│${RESET} ${ICON_BOMB} ${msg} ${RED}${BOLD}│${RESET}"
    echo -e "${RED}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo
}

# Info message
info_msg() {
    local msg="$1"
    echo -e "${CYAN}${ICON_CRYSTAL}${RESET} ${msg}"
}

# Warning message
warn_msg() {
    local msg="$1"
    echo -e "${YELLOW}${ICON_SWORD}${RESET} ${msg}"
}

# Stylized menu
show_menu() {
    echo -e "${GRAD1}█${GRAD2}█${GRAD3}█${GRAD4}█${GRAD5}█${GRAD6}█${RESET} ${BOLD}ANYMEX CONTROL PANEL${RESET} ${GRAD6}█${GRAD5}█${GRAD4}█${GRAD3}█${GRAD2}█${GRAD1}█${RESET}"
    echo
    echo -e "${BOLD}${CYAN}╔═══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}                                                     ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}  ${ICON_ROBOT} ${GREEN}${BOLD}[I]${RESET} ${ICON_DIAMOND} Install AnymeX ${GRAY}(Get Started)${RESET}      ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}      ${GREEN}Deploy multi-service tracking${RESET}               ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}                                                     ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}  ${ICON_LIGHTNING} ${YELLOW}${BOLD}[U]${RESET} ${ICON_COMET} Update AnymeX ${GRAY}(Stay Current)${RESET}     ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}      ${YELLOW}Upgrade to the latest version${RESET}               ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}                                                     ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}  ${ICON_BOMB} ${RED}${BOLD}[R]${RESET} ${ICON_SWORD} Remove AnymeX ${GRAY}(Clean Slate)${RESET}       ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}      ${RED}Remove all AnymeX components${RESET}               ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}                                                     ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}  ${ICON_GHOST} ${CYAN}${BOLD}[Q]${RESET} ${ICON_MAGIC} Quit ${GRAY}(Exit)${RESET}                     ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}      ${CYAN}Return to reality${RESET}                        ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}║${RESET}                                                     ${CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${CYAN}╚═══════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -ne "${BOLD}${WHITE}Choose your action${RESET} ${GRAY}(I/U/R/Q)${RESET} ${ICON_MAGIC}: "
}

# Version selection menu
version_menu() {
    echo
    for char in "V" "E" "R" "S" "I" "O" "N" " " "S" "E" "L" "E" "C" "T" "I" "O" "N"; do
        echo -ne "${BOLD}${PURPLE}$char${RESET}"
        sleep 0.05
    done
    echo
    echo
    
    echo -e "${BOLD}${GRAD2}╔═══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}                                                     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}  ${ICON_CROWN} ${GREEN}${BOLD}[S]${RESET} Stable Release ${GRAY}(Recommended)${RESET}         ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}      ${ICON_SHIELD} Reliable and tested version             ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}                                                     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}  ${ICON_LIGHTNING} ${YELLOW}${BOLD}[P]${RESET} Pre-release ${GRAY}(Bleeding Edge)${RESET}          ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}      ${ICON_FIRE} Latest features, may have bugs          ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}                                                     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}╚═══════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -ne "${BOLD}${WHITE}Choose your version${RESET} ${GRAY}(S/P)${RESET} ${ICON_MAGIC}: "
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
    local alias_line="alias anymex-updater='bash <(curl -s https://raw.githubusercontent.com/Shebyyy/dartotsuInstall/refs/heads/main/anymex.sh) update'"

    if grep -Fxq "$alias_line" "$shell_rc" 2>/dev/null; then
        echo -ne "${YELLOW}${ICON_SWORD}${RESET} The 'anymex-updater' alias already exists in $(basename "$shell_rc"). Remove it? [y/N]: "
        read -r remove_response
        case "$remove_response" in
            [yY][eE][sS]|[yY])
                sed -i "\|$alias_line|d" "$shell_rc"
                echo -e " ${GREEN}${ICON_STAR} Alias removed from $(basename "$shell_rc")${RESET}"
                ;;
            *)
                echo -e " ${CYAN}${ICON_CRYSTAL} Keeping existing alias.${RESET}"
                ;;
        esac
    else
        echo -ne "${CYAN}${ICON_MAGIC}${RESET} Add 'anymex-updater' alias to $(basename "$shell_rc")? [y/N]: "
        read -r add_response
        case "$add_response" in
            [yY][eE][sS]|[yY])
                echo "$alias_line" >> "$shell_rc"
                echo -e " ${GREEN}${ICON_STAR} Alias added to $(basename "$shell_rc")${RESET}"
                info_msg "Run '${BOLD}anymex-updater${RESET}' to update anytime!"
                info_msg "Run '${BOLD}source $shell_rc${RESET}' or restart terminal to activate."
                ;;
            *)
                echo -e " ${YELLOW}${ICON_SWORD} Skipped adding alias${RESET}"
                ;;
        esac
    fi
}

# =============================================================================
# 🛠️ ENHANCED DEPENDENCY MANAGEMENT
# =============================================================================

is_containerized() {
    [ -f /.dockerenv ] || [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ]
}

check_dependencies() {
    local missing_deps=()
    local optional_deps=()
    
    # Check command-line tools
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v unzip >/dev/null 2>&1 || missing_deps+=("unzip")
    command -v wget >/dev/null 2>&1 || missing_deps+=("wget")
    
    # Check required libraries
    if command -v pkg-config >/dev/null 2>&1; then
        pkg-config --exists libmpv 2>/dev/null || missing_deps+=("libmpv2")
        pkg-config --exists webkit2gtk-4.1 2>/dev/null || missing_deps+=("libwebkit2gtk-4.1-0")
        pkg-config --exists gtk+-3.0 2>/dev/null || missing_deps+=("gtk3")
    else
        missing_deps+=("pkg-config" "libmpv2" "libwebkit2gtk-4.1-0" "gtk3")
    fi
    
    # Check optional tools
    command -v git >/dev/null 2>&1 || optional_deps+=("git")
    
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
            echo -ne "${YELLOW}${BOLD}Install required dependencies automatically?${RESET} ${GRAY}(y/N)${RESET}: "
            read -n 1 INSTALL_DEPS
            echo
            if [[ "${INSTALL_DEPS,,}" == "y" ]]; then
                install_packages "${missing_deps[@]}"
            else
                error_exit "Required dependencies must be installed: ${missing_deps[*]}"
            fi
        fi
    elif [ ${#optional_deps[@]} -ne 0 ]; then
        info_msg "Optional dependencies not found: ${optional_deps[*]}"
        echo -e "${GRAY}These are not required but may enhance functionality.${RESET}"
    else
        info_msg "All dependencies are satisfied!"
    fi
}

install_packages() {
    local deps=("$@")
    local install_cmd=""
    local update_cmd=""
    local distro=""
    
    if command -v apt >/dev/null 2>&1; then
        distro="debian"
        update_cmd="sudo apt update -y"
        install_cmd="sudo apt install -y"
        deps=("${deps[@]/libmpv2/libmpv2}")
        deps=("${deps[@]/libwebkit2gtk-4.1-0/libwebkit2gtk-4.1-0}")
        deps=("${deps[@]/gtk3/libgtk-3-dev}")
        deps=("${deps[@]/pkg-config/pkg-config}")
    elif command -v dnf >/dev/null 2>&1; then
        distro="fedora"
        install_cmd="sudo dnf install -y"
        deps=("${deps[@]/libmpv2/mpv-libs}")
        deps=("${deps[@]/libwebkit2gtk-4.1-0/webkit2gtk4.1}")
        deps=("${deps[@]/gtk3/gtk3-devel}")
        deps=("${deps[@]/pkg-config/pkgconf-devel}")
    elif command -v pacman >/dev/null 2>&1; then
        distro="arch"
        update_cmd="sudo pacman -Sy"
        install_cmd="sudo pacman -S --noconfirm"
        deps=("${deps[@]/libmpv2/mpv}")
        deps=("${deps[@]/libwebkit2gtk-4.1-0/webkit2gtk-4.1}")
        deps=("${deps[@]/gtk3/gtk3}")
        deps=("${deps[@]/pkg-config/pkgconf}")
    elif command -v zypper >/dev/null 2>&1; then
        distro="opensuse"
        install_cmd="sudo zypper install -y"
        deps=("${deps[@]/libmpv2/libmpv2}")
        deps=("${deps[@]/libwebkit2gtk-4.1-0/webkit2gtk3-devel}")
        deps=("${deps[@]/gtk3/gtk3-devel}")
        deps=("${deps[@]/pkg-config/pkg-config}")
    elif command -v brew >/dev/null 2>&1; then
        distro="macos"
        install_cmd="brew install"
        deps=("${deps[@]/libmpv2/mpv}")
        deps=("${deps[@]/libwebkit2gtk-4.1-0/}") # WebKit not available via Homebrew
        deps=("${deps[@]/gtk3/gtk+3}")
        deps=("${deps[@]/pkg-config/pkg-config}")
    else
        error_exit "No supported package manager found! Install manually: ${deps[*]}"
    fi
    
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
    
    if [ -n "$update_cmd" ]; then
        echo -ne "${CYAN}${ICON_DIAMOND}${RESET} Updating package lists..."
        if eval "$update_cmd" >/dev/null 2>&1; then
            echo -e " ${GREEN}${ICON_STAR}${RESET}"
        else
            echo -e " ${YELLOW}${ICON_SWORD} Update failed, continuing...${RESET}"
        fi
    fi
    
    echo -ne "${CYAN}${ICON_DIAMOND}${RESET} Installing dependencies..."
    if eval "$install_cmd ${deps[*]}" >/dev/null 2>&1; then
        echo -e " ${GREEN}${ICON_STAR} Done!${RESET}"
        info_msg "Dependencies installed successfully!"
    else
        echo -e " ${RED}${ICON_BOMB} Failed!${RESET}"
        warn_msg "Attempting to install packages individually..."
        local failed_packages=()
        for pkg in "${deps[@]}"; do
            echo -ne "  Installing $pkg..."
            if eval "$install_cmd $pkg" >/dev/null 2>&1; then
                echo -e " ${GREEN}${ICON_STAR}${RESET}"
            else
                echo -e " ${RED}${ICON_BOMB}${RESET}"
                failed_packages+=("$pkg")
            fi
        done
        if [ ${#failed_packages[@]} -ne 0 ]; then
            error_exit "Failed to install: ${failed_packages[*]}. Install manually."
        fi
    fi
}

verify_installation() {
    local critical_deps=("curl" "unzip" "wget")
    local failed_deps=()
    
    for dep in "${critical_deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            failed_deps+=("$dep")
        fi
    done
    
    if [ ${#failed_deps[@]} -ne 0 ]; then
        error_exit "Critical dependencies still missing: ${failed_deps[*]}"
    fi
    
    if command -v pkg-config >/dev/null 2>&1; then
        if ! pkg-config --exists libmpv 2>/dev/null; then
            warn_msg "libmpv2 may not be installed - some features may not work"
        fi
        if ! pkg-config --exists webkit2gtk-4.1 2>/dev/null; then
            warn_msg "libwebkit2gtk-4.1-0 may not be installed - some features may not work"
        fi
    fi
    
    info_msg "Installation verification completed!"
}

# =============================================================================
# 🛠️ CORE FUNCTIONS
# =============================================================================

error_exit() {
    error_msg "$1"
    echo -e "${GRAY}${DIM}Press any key to exit...${RESET}"
    read -n 1
    exit 1
}

download_with_progress() {
    local url="$1"
    local output="$2"
    local filename=$(basename "$url")
    
    echo -ne "${CYAN}${ICON_DIAMOND}${RESET} Downloading ${BOLD}${filename}${RESET}..."
    curl -sL "$url" -o "$output" &
    local curl_pid=$!
    spinner $curl_pid
    wait $curl_pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo -e " ${GREEN}${ICON_STAR} Done!${RESET}"
    else
        echo -e " ${RED}${ICON_BOMB} Failed!${RESET}"
        return 1
    fi
}

install_app() {
    section_header "INSTALLATION PROCESS" "${ICON_DIAMOND}"
    
    info_msg "Checking system dependencies..."
    check_dependencies
    verify_installation
    echo -e "  ${GREEN}${ICON_STAR} All dependencies verified!${RESET}"
    echo
    
    version_menu
    read -n 1 ANSWER
    echo
    
    case "${ANSWER,,}" in
        p)
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases"
            info_msg "Fetching pre-release versions..."
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
    
    ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | grep "AnymeX-Linux.zip" | cut -d '"' -f 4 | head -n 1)
    
    if [ -z "$ASSET_URL" ]; then
        error_exit "No AnymeX-Linux.zip asset found in the release!"
    fi
    
    echo
    if ! download_with_progress "$ASSET_URL" "/tmp/$APP_NAME.zip"; then
        error_exit "Download failed!"
    fi
    
    echo
    info_msg "Installing to ${BOLD}$INSTALL_DIR${RESET}..."
    
    if [ -d "$INSTALL_DIR" ]; then
        warn_msg "Existing installation detected - removing old version..."
        rm -rf "$INSTALL_DIR"
    fi
    
    mkdir -p "$INSTALL_DIR"
    
    echo -ne "${CYAN}${ICON_DIAMOND}${RESET} Extracting files..."
    if unzip "/tmp/$APP_NAME.zip" -d "$INSTALL_DIR" > /dev/null 2>&1; then
        echo -e " ${GREEN}${ICON_STAR} Done!${RESET}"
    else
        echo -e " ${RED}${ICON_BOMB} Failed!${RESET}"
        error_exit "Failed to extract application files!"
    fi
    
    APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f -executable -print -quit)"
    if [ -z "$APP_EXECUTABLE" ]; then
        error_exit "No executable found in the extracted files!"
    fi
    
    chmod +x "$APP_EXECUTABLE"
    
    mkdir -p "$HOME/.local/bin"
    ln -sf "$APP_EXECUTABLE" "$LINK"
    
    echo -ne "${CYAN}${ICON_DIAMOND}${RESET} Installing icon..."
    fallback_icon_url='https://raw.githubusercontent.com/RyanYuuki/AnymeX/main/assets/images/logo.png'
    if wget -q "$fallback_icon_url" -O "$ICON_FILE" 2>/dev/null; then
        echo -e " ${GREEN}${ICON_STAR} Done!${RESET}"
    else
        echo -e " ${YELLOW}${ICON_SWORD} Icon download failed (non-critical)${RESET}"
    fi
    
    echo -ne "${CYAN}${ICON_DIAMOND}${RESET} Creating desktop entry..."
    mkdir -p "$(dirname "$DESKTOP_FILE")"
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=Multi-Service Anime & Manga Tracking
Exec=$LINK
Icon=$ICON_FILE
Type=Application
Categories=AudioVideo;Utility;
MimeType=x-scheme-handler/dar;x-scheme-handler/anymex;x-scheme-handler/sugoireads;x-scheme-handler/mangayomi;
EOL
    chmod +x "$DESKTOP_FILE"
    
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    fi
    echo -e " ${GREEN}${ICON_STAR} Done!${RESET}"
    
    add_updater_alias
    
    rm -f "/tmp/$APP_NAME.zip"
    
    echo
    success_msg "$APP_NAME has been installed successfully!"
    info_msg "Launch it from your applications menu or run: ${BOLD}$APP_NAME${RESET}"
    
    echo
    echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
    read -n 1
}

uninstall_app() {
    section_header "UNINSTALLATION PROCESS" "${ICON_SWORD}"
    
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
    
    [ -L "$LINK" ] && rm -f "$LINK" && echo -e "  ${GREEN}✓${RESET} Executable symlink removed"
    [ -d "$INSTALL_DIR" ] && rm -rf "$INSTALL_DIR" && echo -e "  ${GREEN}✓${RESET} Installation directory removed"
    [ -f "$DESKTOP_FILE" ] && rm -f "$DESKTOP_FILE" && echo -e "  ${GREEN}✓${RESET} Desktop entry removed"
    [ -f "$ICON_FILE" ] && rm -f "$ICON_FILE" && echo -e "  ${GREEN}✓${RESET} Icon removed"
    
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
    section_header "UPDATE PROCESS" "${ICON_COMET}"
    
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
                type_text "Thanks for using AnymeX Installer! ${ICON_MAGIC}" 0.05
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

if [ $# -gt 0 ]; then
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
    main_loop
else
    main_loop
fi
