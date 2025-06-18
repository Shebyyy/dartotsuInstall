#!/bin/bash
set -e

# =============================================================================
# 🎯 DARTOTSU INSTALLER - The Definitive Version
# =============================================================================

APP_NAME="Dartotsu"
OWNER="aayush2622"
REPO="Dartotsu"
FILE_ID_FILE='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/latest.txt'

# Installation paths
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
LINK="$HOME/.local/bin/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
ICON_FILE="$HOME/.local/share/icons/$APP_NAME.png"

# =============================================================================
# 🎨 COLORS & ICONS
# =============================================================================

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

GRAD1='\033[38;5;198m'; GRAD2='\033[38;5;199m'; GRAD3='\033[38;5;200m'
GRAD4='\033[38;5;135m'; GRAD5='\033[38;5;99m'; GRAD6='\033[38;5;63m'

ICON_SUCCESS="✅"; ICON_ERROR="❌"; ICON_WARNING="⚠️ "
ICON_INFO="ℹ️ "; ICON_DOWNLOAD="⬇️ "; ICON_INSTALL="📦"
ICON_UNINSTALL="🗑️ "; ICON_UPDATE="🔄"; ICON_ROCKET="🚀"
ICON_SPARKLES="✨"; ICON_FLASK="🧪"

# =============================================================================
# 🎭 UI & ANIMATION FUNCTIONS
# =============================================================================

spinner() {
    local pid=$1; local delay=0.1; local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while ps -p "$pid" > /dev/null; do
        local temp=${spinstr#?}; printf " [${CYAN}%c${RESET}]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}; sleep $delay; printf "\b\b\b\b\b\b"
    done; printf "    \b\b\b\b"
}

show_banner() {
    clear; echo
    echo -e "${GRAD1}  ██████╗  █████╗ ██████╗ ████████╗ ██████╗ ████████╗███████╗██╗   ██╗${RESET}"
    echo -e "${GRAD2}  ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗╚══██╔══╝██╔════╝██║   ██║${RESET}"
    echo -e "${GRAD3}  ██║  ██║███████║██████╔╝   ██║   ██║   ██║   ██║   ███████╗██║   ██║${RESET}"
    echo -e "${GRAD4}  ██║  ██║██╔══██║██╔══██╗   ██║   ██║   ██║   ██║   ╚════██║██║   ██║${RESET}"
    echo -e "${GRAD5}  ██████╔╝██║  ██║██║  ██║   ██║   ╚██████╔╝   ██║   ███████║╚██████╔╝${RESET}"
    echo -e "${GRAD6}  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝ ${RESET}"
    echo; echo -e "${CYAN}${BOLD}                    The Ultimate Anime & Manga Experience${RESET}"
    echo -e "${GRAY}                    ═══════════════════════════════════════${RESET}"; echo
}

show_menu() {
    echo -e "${BOLD}${PURPLE}┌─ SELECT ACTION ────────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}                                                   ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}  ${ICON_INSTALL} ${GREEN}${BOLD}[I]${RESET} Install Dartotsu                      ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}  ${ICON_UPDATE} ${YELLOW}${BOLD}[U]${RESET} Update Dartotsu                       ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}  ${ICON_UNINSTALL} ${RED}${BOLD}[R]${RESET} Remove Dartotsu                       ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}  ${ICON_SPARKLES} ${CYAN}${BOLD}[Q]${RESET} Quit                                  ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}                                                   ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}└────────────────────────────────────────────────────┘${RESET}"
    echo; echo -ne "${BOLD}${WHITE}Your choice${RESET} ${GRAY}(I/U/R/Q)${RESET}: "
}

version_menu() {
    echo; echo -e "${BOLD}${CYAN}┌─ VERSION SELECTION ────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}                                                   ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_ROCKET} ${GREEN}${BOLD}[S]${RESET} Stable Release ${GRAY}(Recommended)${RESET}          ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_SPARKLES} ${YELLOW}${BOLD}[P]${RESET} Pre-release ${GRAY}(Latest Features)${RESET}        ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_FLASK} ${BLUE}${BOLD}[A]${RESET} Alpha Build ${GRAY}(Experimental)${RESET}          ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}                                                   ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}└────────────────────────────────────────────────────┘${RESET}"
    echo; echo -ne "${BOLD}${WHITE}Your choice${RESET} ${GRAY}(S/P/A)${RESET}: "
}

section_header() {
    echo; echo -e "${BOLD}${BLUE}╭─────────────────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${BLUE}│${RESET} $2 ${BOLD}${WHITE}$1${RESET} ${BLUE}│${RESET}"
    echo -e "${BOLD}${BLUE}╰─────────────────────────────────────────────────────╯${RESET}"; echo
}

# =============================================================================
# 🛠️ MESSAGE & DOWNLOAD FUNCTIONS
# =============================================================================

error_exit() {
    echo; echo -e "${RED}${BOLD}┌─ ERROR! ───────────────────────────────────────────┐${RESET}"
    echo -e "${RED}${BOLD}│${RESET} ${ICON_ERROR} $1"
    # Pad the error message to fit the box
    printf "%*s" $((49 - ${#1})) ""
    echo -e "${RED}${BOLD}│${RESET}"; echo -e "${RED}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo; echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"; read -n 1; exit 1
}

success_msg() { echo; echo -e "${GREEN}${BOLD}┌─ SUCCESS! ─────────────────────────────────────────┐${RESET}"; echo -e "${GREEN}${BOLD}│${RESET} ${ICON_SUCCESS} $1 ${GREEN}${BOLD}│${RESET}"; echo -e "${GREEN}${BOLD}└────────────────────────────────────────────────────┘${RESET}"; echo; }
info_msg() { echo -e "${CYAN}${ICON_INFO}${RESET} $1"; }
warn_msg() { echo -e "${YELLOW}${ICON_WARNING}${RESET} $1"; }

check_dependencies() {
    local missing_deps=()
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v unzip >/dev/null 2>&1 || missing_deps+=("unzip")
    command -v yt-dlp >/dev/null 2>&1 || missing_deps+=("yt-dlp")
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        error_exit "Missing dependencies: ${missing_deps[*]}. Please install them.
        'yt-dlp' is required for Alpha downloads.
        Install it with: python3 -m pip install -U yt-dlp"
    fi
}

download_with_progress() {
    local url="$1"
    local output="$2"
    local filename
    
    (
        if [[ "$url" == *"drive.google.com"* ]]; then
            filename="$APP_NAME-alpha.zip"
            info_msg "Using yt-dlp for reliable Google Drive download..."
            local file_id; file_id=$(echo "$url" | sed -n 's/.*id=\([^&]*\).*/\1/p')
            local view_url="https://drive.google.com/file/d/$file_id/view"
            yt-dlp --quiet --no-warnings --no-check-certificate -o "$output" "$view_url"
        else
            filename=$(basename "$url")
            info_msg "Using curl for standard download..."
            curl -sL --fail "$url" -o "$output"
        fi
    ) &
    local download_pid=$!

    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Downloading ${BOLD}${filename}${RESET}..."
    spinner $download_pid
    wait $download_pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"; return 0
    else
        echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"; return 1
    fi
}

# =============================================================================
# 🚀 MAIN FUNCTIONS
# =============================================================================

install_app() {
    section_header "INSTALLATION PROCESS" "${ICON_INSTALL}"
    
    info_msg "Checking system dependencies..."
    check_dependencies
    echo -e "  ${GREEN}${ICON_SUCCESS} All dependencies found!"
    
    version_menu
    read -n 1 ANSWER
    echo
    
    local ASSET_URL=""
    local DOWNLOAD_FILENAME="$APP_NAME.zip"
    
    case "${ANSWER,,}" in
        p)
            info_msg "Fetching pre-release versions..."
            ASSET_URL=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            ;;
        a)
            info_msg "Fetching alpha build info..."
            local FILE_ID; FILE_ID="$(curl -s --fail "$FILE_ID_FILE")"
            if [ -z "$FILE_ID" ]; then error_exit "Could not retrieve Alpha build File ID."; fi
            info_msg "Found Alpha build with File ID: ${BOLD}${FILE_ID}${RESET}"
            ASSET_URL="https://drive.google.com/uc?export=download&id=${FILE_ID}"
            DOWNLOAD_FILENAME="$APP_NAME-alpha.zip"
            ;;
        s|"")
            info_msg "Fetching stable release..."
            ASSET_URL=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            ;;
        *)
            warn_msg "Invalid selection, defaulting to stable release..."
            ASSET_URL=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            ;;
    esac
    
    if [ -z "$ASSET_URL" ]; then error_exit "No downloadable asset found for the selected version."; fi
    
    if ! download_with_progress "$ASSET_URL" "/tmp/$DOWNLOAD_FILENAME"; then error_exit "Download failed!"; fi
    
    info_msg "Installing to ${BOLD}$INSTALL_DIR${RESET}..."
    if [ -d "$INSTALL_DIR" ]; then warn_msg "Existing installation detected - removing old version..."; rm -rf "$INSTALL_DIR"; fi
    mkdir -p "$INSTALL_DIR"
    
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Verifying and extracting files..."
    
    if ! unzip -t "/tmp/$DOWNLOAD_FILENAME" > /dev/null 2>&1; then
        echo -e " ${RED}${ICON_ERROR}${RESET}"; info_msg "File info: $(file "/tmp/$DOWNLOAD_FILENAME")"
        error_exit "Downloaded file is not a valid zip archive!"
    fi
    
    if unzip -o "/tmp/$DOWNLOAD_FILENAME" -d "$INSTALL_DIR" > /dev/null 2>&1; then echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"; else echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"; error_exit "Failed to extract application files!"; fi
    
    local APP_EXECUTABLE; APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f -executable -print -quit)"
    if [ -z "$APP_EXECUTABLE" ]; then APP_EXECUTABLE="$(find "$INSTALL_DIR" -name "*.AppImage" -o -name "$APP_NAME" -o -name "${APP_NAME,,}" | head -n1)"; if [ -z "$APP_EXECUTABLE" ]; then error_exit "Could not find an executable in the archive!"; fi; fi
    chmod +x "$APP_EXECUTABLE"
    
    mkdir -p "$HOME/.local/bin"; ln -sf "$APP_EXECUTABLE" "$LINK"
    
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Installing icon and desktop entry..."
    mkdir -p "$(dirname "$ICON_FILE")"; wget -q 'https://raw.githubusercontent.com/grayankit/dartotsuInstall/main/Dartotsu.png' -O "$ICON_FILE"
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
    if command -v update-desktop-database >/dev/null 2>&1; then update-desktop-database "$HOME/.local/share/applications" 2>/dev/null; fi
    echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    
    rm -f "/tmp/$DOWNLOAD_FILENAME"
    success_msg "$APP_NAME has been installed successfully!"
    info_msg "Launch it from your applications menu or run: ${BOLD}$APP_NAME${RESET}"
    echo; echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"; read -n 1
}

uninstall_app() {
    section_header "UNINSTALLATION PROCESS" "${ICON_UNINSTALL}"
    if [ ! -d "$INSTALL_DIR" ] && [ ! -L "$LINK" ]; then warn_msg "$APP_NAME is not installed."; read -n 1; return; fi
    echo -ne "${YELLOW}${BOLD}Are you sure you want to remove $APP_NAME?${RESET} ${GRAY}(y/N)${RESET}: "; read -n 1 CONFIRM; echo
    if [[ "${CONFIRM,,}" != "y" ]]; then info_msg "Uninstallation cancelled."; read -n 1; return; fi
    info_msg "Removing $APP_NAME components..."; echo
    [ -L "$LINK" ] && rm -f "$LINK" && echo "  ${GREEN}✓${RESET} Executable symlink removed"
    [ -d "$INSTALL_DIR" ] && rm -rf "$INSTALL_DIR" && echo "  ${GREEN}✓${RESET} Installation directory removed"
    [ -f "$DESKTOP_FILE" ] && rm -f "$DESKTOP_FILE" && echo "  ${GREEN}✓${RESET} Desktop entry removed"
    [ -f "$ICON_FILE" ] && rm -f "$ICON_FILE" && echo "  ${GREEN}✓${RESET} Icon removed"
    if command -v update-desktop-database >/dev/null 2>&1; then update-desktop-database "$HOME/.local/share/applications" 2>/dev/null; fi
    success_msg "$APP_NAME has been completely removed!"
    read -n 1
}

update_app() { section_header "UPDATE PROCESS" "${ICON_UPDATE}"; install_app; }

# =============================================================================
# 🎯 SCRIPT EXECUTION
# =============================================================================

main_loop() {
    while true; do
        show_banner; show_menu; read -n 1 ACTION; echo
        case "${ACTION,,}" in
            i|install) install_app ;;
            u|update) update_app ;;
            r|remove|uninstall) uninstall_app ;;
            q|quit|exit) echo; echo -e "${CYAN}${BOLD}Thanks for using Dartotsu Installer! ${ICON_SPARKLES}${RESET}"; exit 0 ;;
            *) warn_msg "Invalid selection!"; sleep 2 ;;
        esac
    done
}

if [ -t 0 ]; then main_loop; else
    ACTION="$1"; show_banner
    case "${ACTION,,}" in
        install) install_app ;;
        update) update_app ;;
        uninstall|remove) uninstall_app ;;
        *) echo -e "${RED}Usage: $0 [install|update|uninstall]${RESET}"; exit 1 ;;
    esac
fi
