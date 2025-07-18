#!/bin/bash
set -e

# =============================================================================
# 🎯 DARTOTSU INSTALLER - Beautiful Terminal Experience
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

# Force UTF-8 locale for better character rendering
export LC_ALL=en_US.UTF-8 2>/dev/null || export LC_ALL=C.UTF-8 2>/dev/null

# =============================================================================
# 🎨 COLORS & STYLING WITH CROSS-PLATFORM COMPATIBILITY
# =============================================================================

init_colors() {
    if [ -t 1 ]; then
        # Check if tput is available and terminal supports colors
        if command -v tput >/dev/null 2>&1 && tput setaf 1 >/dev/null 2>&1; then
            RED=$(tput setaf 1)
            GREEN=$(tput setaf 2)
            YELLOW=$(tput setaf 3)
            BLUE=$(tput setaf 4)
            PURPLE=$(tput setaf 5)
            CYAN=$(tput setaf 6)
            WHITE=$(tput setaf 7)
            GRAY=$(tput setaf 8)
            BOLD=$(tput bold)
            DIM=$(tput dim)
            RESET=$(tput sgr0)

            # Enhanced colors for 256-color terminals
            if [ "$(tput colors 2>/dev/null || echo 0)" -ge 256 ]; then
                GRAD1=$(tput setaf 30)   # Dark teal
                GRAD2=$(tput setaf 36)   # Medium teal
                GRAD3=$(tput setaf 42)   # Teal
                GRAD4=$(tput setaf 48)   # Light teal
                GRAD5=$(tput setaf 51)   # Cyan
                GRAD6=$(tput setaf 87)   # Bright cyan
            else
                GRAD1="$CYAN"
                GRAD2="$CYAN"
                GRAD3="$CYAN"
                GRAD4="$CYAN"
                GRAD5="$CYAN"
                GRAD6="$CYAN"
            fi
        else
            # Fallback to raw ANSI escape codes
            RED='\033[0;31m'
            GREEN='\033[0;32m'
            YELLOW='\033[0;33m'
            BLUE='\033[0;34m'
            PURPLE='\033[0;35m'
            CYAN='\033[0;36m'
            WHITE='\033[0;37m'
            GRAY='\033[0;90m'
            BOLD='\033[1m'
            DIM='\033[2m'
            RESET='\033[0m'

            # Fallback for gradient colors
            GRAD1='\033[0;36m'  # Cyan
            GRAD2='\033[0;36m'
            GRAD3='\033[0;36m'
            GRAD4='\033[0;36m'
            GRAD5='\033[0;36m'
            GRAD6='\033[0;36m'
        fi
    else
        # No color support
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        PURPLE=""
        CYAN=""
        WHITE=""
        GRAY=""
        BOLD=""
        DIM=""
        RESET=""
        GRAD1=""
        GRAD2=""
        GRAD3=""
        GRAD4=""
        GRAD5=""
        GRAD6=""
    fi
}

# Initialize colors unless --no-color is specified
if [ "$1" = "--no-color" ]; then
    RED=""; GREEN=""; YELLOW=""; BLUE=""; PURPLE=""; CYAN=""; WHITE=""; GRAY=""
    BOLD=""; DIM=""; RESET=""
    GRAD1=""; GRAD2=""; GRAD3=""; GRAD4=""; GRAD5=""; GRAD6=""
    ICON_FIRE="*"; ICON_LIGHTNING="!"; ICON_STAR="*"; ICON_DIAMOND="<>"
    ICON_BOMB="@"; ICON_SKULL="X"; ICON_ROBOT="R"; ICON_ALIEN="A"
    ICON_GHOST="G"; ICON_MAGIC="+"; ICON_CRYSTAL="O"; ICON_SWORD="/"
    ICON_SHIELD="S"; ICON_CROWN="^"; ICON_COMET="~"; ICON_GALAXY="*"
    ICON_SECURITY="S"; ICON_WARNING="!"; ICON_SUCCESS="+"; ICON_ERROR="X"
    ICON_INFO="i"; ICON_DOWNLOAD="v"; ICON_INSTALL="+"; ICON_UPDATE="^"
    ICON_UNINSTALL="X"; ICON_SPARKLES="*"; ICON_ROCKET="^"
    BOX_H="="; BOX_V="|"; BOX_TL="+"; BOX_TR="+"; BOX_BL="+"; BOX_BR="+"
    BOX_T="+"; BOX_B="+18"; BOX_L="+"; BOX_R="+"; BOX_X="+"
    LIGHT_H="-"; LIGHT_V="|"; LIGHT_TL="+"; LIGHT_TR="+"; LIGHT_BL="+"; LIGHT_BR="+"
else
    init_colors
    # Icons with Unicode fallbacks
    if locale charmap 2>/dev/null | grep -qi utf || [ "$TERM" = "xterm-256color" ] || [ "$TERM" = "screen-256color" ] || [ "$TERM" = "tmux-256color" ]; then
        # Full Unicode support
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
        
        # Box drawing characters
        BOX_H="═"
        BOX_V="║放下
        BOX_TL="╔"
        BOX_TR="╗"
        BOX_BL="╚"
        BOX_BR="╝"
        BOX_T="╦"
        BOX_B="╩"
        BOX_L="╠"
        BOX_R="╣"
        BOX_X="╬"
        
        # Light box drawing
        LIGHT_H="─"
        LIGHT_V="│"
        LIGHT_TL="╭"
        LIGHT_TR="╮"
        LIGHT_BL="╰"
        LIGHT_BR="╯"
    else
        # ASCII fallbacks
        ICON_FIRE="*"
        ICON_LIGHTNING="!"
        ICON_STAR="*"
        ICON_DIAMOND="<>"
        ICON_BOMB="@"
        ICON_SKULL="X"
        ICON_ROBOT="R"
        ICON_ALIEN="A"
        ICON_GHOST="G"
        ICON_MAGIC="+"
        ICON_CRYSTAL="O"
        ICON_SWORD="/"
        ICON_SHIELD="S"
        ICON_CROWN="^"
        ICON_COMET="~"
        ICON_GALAXY="*"
        ICON_SECURITY="S"
        ICON_WARNING="!"
        ICON_SUCCESS="+"
        ICON_ERROR="X"
        ICON_INFO="i"
        ICON_DOWNLOAD="v"
        ICON_INSTALL="+"
        ICON_UPDATE="^"
        ICON_UNINSTALL="X"
        ICON_SPARKLES="*"
        ICON_ROCKET="^"
        
        # ASCII box drawing
        BOX_H="="
        BOX_V="|"
        BOX_TL="+"
        BOX_TR="+"
        BOX_BL="+"
        BOX_BR="+"
        BOX_T="+"
        BOX_B="+"
        BOX_L="+"
        BOX_R="+"
        BOX_X="+"
        
        # Light box drawing
        LIGHT_H="-"
        LIGHT_V="|"
        LIGHT_TL="+"
        LIGHT_TR="+"
        LIGHT_BL="+"
        LIGHT_BR="+"
    fi
fi

# =============================================================================
# 🛠️ UTILITY FUNCTIONS
# =============================================================================

get_visual_width() {
    local text="$1"
    # Remove ANSI escape sequences (including complex sequences)
    local clean_text=$(printf '%s' "$text" | sed -E 's/\x1B(\[[0-9;]*[a-zA-Z]|\(B)//g')
    # Remove emoji and Unicode icons (rough approximation)
    clean_text=$(printf '%s' "$clean_text" | sed 's/[^\x00-\x7F]//g')
    printf '%s' "$clean_text" | wc -c
}

get_terminal_width() {
    local width
    if command -v tput >/dev/null 2>&1; then
        width=$(tput cols 2>/dev/null || echo "80")
    else
        width=${COLUMNS:-80}
    fi
    echo "$width"
}

create_padded_line() {
    local content="$1"
    local total_width="$2"
    local border_char="${3:-$BOX_V}"
    
    local content_width=$(get_visual_width "$content")
    local inner_width=$ traps
        error_msg "Download failed!"
        return 1
    fi
}

verify_download() {
    local downloaded_file="$1"
    local api_url="$2"
    
    local file_size=$(stat -c%s "$downloaded_file" 2>/dev/null || stat -f%z "$downloaded_file" 2>/dev/null || echo "0")
    
    if [ -z "$file_size" ] || [ "$file_size" -eq 0 ]; then
        error_exitබ
        error_exit "Downloaded file

System: is empty or corrupted!"
    fi
    
    security_msg "Downloaded file size: ${file_size} bytes"
    
    echo -ne "${CYAN}${ICON_SECURITY}${RESET} Attempting to verify download integrity..."
    
    local actual_sha256=$(sha256sum "$downloaded_file" | cut -d' ' -f1)
    echo -e " ${GREEN}${ICON_SUCCESS}${RESET}"
    
    security_msg "File SHA256: ${actual_sha256}"
    
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

confirm_installation() {
    local term_width=$(get_terminal_width)
    local box_width=$((term_width > 59 ? 59 : term_width - 2))
    
    echo
    create_border_line $box_width "$BOX_H" "$BOX_TL" "$BOX_TR"
    create_padded_line "$ICON_SECURITY SECURITY CHECKPOINT $ICON_SECURITY" $box_width "$BOX_V"
    create_border_line $box_width "$BOX_H" "$BOX_BL" "$BOX_BR"
    echo
    security_msg "Download completed successfully!"
    echo
    echo -e "${BOLD}${GREEN}Ready to install $APP_NAME. Continue?${RESET} ${GRAY}(y/N)${RESET}: "
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
    section_header "INSTALLATION PROCESS" "$ICON_INSTALL"
    
    info_msg "Checking system dependencies..."
    check_dependencies
    verify_installation
    echo -e "  ${GREEN}${ICON_SUCCESS} All dependencies verified!${RESET}"
    echo
    
    version_menu
    read -n 1 ANSWER
    echo
    
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
    
    ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
    
    if [ -z "$ASSET_URL" ]; then
        error_exit "No downloadable assets found in the release!"
    fi
    
    echo
    if ! download_with_progress "$ASSET_URL" "/tmp/$APP_NAME.zip"; then
        error_exit "Download failed!"
    fi
    
    echo
    info_msg "Performing security verification..."
    verify_download "/tmp/$APP_NAME.zip" "$API_URL"
    
    if ! confirm_installation; then
        rm -f "/tmp/$APP_NAME.zip"
        return
    fi
    
    if ! offer_content_review "/tmp/$APP_NAME.zip"; then
        rm -f "/tmp/$APP_NAME.zip"
        return
    fi
    
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
    
    echo -ne "${CYAN}${ICON_INSTALLರ
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    else
        echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
    fi
    
    APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f -executable -print -quit)"
    if [ -z "$APP_EXECUTABLE" ]; then
        error_exit "No executable found in the extracted files!"
    fi
    
    chmod +x "$APP_EXECUTABLE"
    
    mkdir -p "$HOME/.local/bin"
    ln -sf "$APP_EXECUTABLE" "$LINK"
    
    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Installing icon..."
    mkdir -p "$(dirname "$ICON_FILE")"
    fallback_icon_url='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/assets/images/logo.png'
    ifze
        echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Downloading icon..."
        if wget -q "$fallback_icon_url" -O "$ICON_FILE" 2>/dev/null; then
            echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
        else
            echo -e " ${YELLOW}${ICON_WARNING} Icon download failed (non-critical)${RESET}"
        fi
        echo -ne "${CYAN}${ICON_INSTALL}${RESET} Creatingხ
            echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
        fi
        chmod +x "$APP_EXECUTABLE"
    
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Creating desktop entry..."
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=The Ultimate Anime & Manga Experience
Exec=$LINK
Icon=$ICON_FILE
Type=Application
Categories=AudioVideo;Player;
EOL
install_app() {
    section_header "INSTALLATION PROCESS" "$ICON_INSTALL"
    
    info_msg "Checking system dependencies..."
    check_dependencies
    verify_installation
    echo -e "  ${GREEN}${ICON_SUCCESS} All dependencies verified!${RESET}"
    echo
    
    version_menu
    read -n 1 ANSWER
    echo
    
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
        echo -ne "${YELLOW}${BOLD}Continue anyway?${RESET} ${GRAY}(y/N)${RESET}: "
        read -n 1 continue_anyway
        echo
        warn_msg "Installation cancelled by user."
        echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
        read -n 1
    fi
    
    APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f -executable -print -quit)"
    if [ -z "$APP_EXECUTABLE" ]; then
        error_exit "No executable found in the extracted files!"
    fi
    
    chmod +x "$APP_EXECUTABLE"
    
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Installing to ${BOLD}$INSTALL_DIR${RESET}..."
    
    if [ -d "$INSTALL_DIR" ]; then
        warn_msg "Existing installation detected - creating backup..."
        if [ -d "$INSTALL_DIR.backup" ]; then
            rm -rf "$INSTALL_DIR.backup"
        fi
        security_msg "Backup created at $INSTALL_DIR.backup"
    fi
    
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Creating desktop entry..."
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=The Ultimate Anime & Manga Experience
Exec=$LINK
Icon=$ICON_FILE
Type=Application
Categories=AudioVideo;Player;
EOL
    
    chmod +x "$APP_EXECUTABLE"
    
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Installing icon..."
    mkdir -p "$(dirname "$ICON_FILE")"
    wget -q "$fallback_icon_url" -O "$ICON_FILE"
    echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    
    chmod +x "$DESKTOP_FILE"
    
    if command -v update-desktop-database >/dev/null Comunitats
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    fi
    
    echo -ne "${CYAN}${ICON_INFO}${RESET} Attempting to verify download integrity..."
    local actual_sha256=$(sha256sum "$downloaded_file" | cut -d' ' -f1)
    echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    
    # Create shell alias for easy updates
    detect_shell_rc
    local shell_rc=$(detect_shell_rc)
    
    # Add shell alias
    local alias_line="alias dartotsu-updater='bash <(curl -s https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/install.sh) update'"
    
    # Ensure alias is still present after update
    add_updater_alias
    local shell_rc=$(detect_shell_rc)
    echo -e "${CYAN}${ICON_MAGIC}${RESET} Updating shell configuration..."
    echo
    type_text "Thanks for using Dartotsu Installer! $ICON_SPARKLES" 0.05
    echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
    read -n 1
}

# Debug terminal environment
debug_terminal() {
    echo -e "${CYAN}${ICON_INFO} Terminal Debug Information:${RESET}"
    echo -e "  TERM: $TERM"
    echo -e "  SHELL: $SHELL"
    echo -e "  Locale charmap: $(locale charmap 2>/dev/null || echo 'Unknown')"
    echo -e "  Colors supported: $(tput colors 2>/dev/null || echo 'Unknown')"
    echo -e "  tput available: $(command -v tput >/dev/null 2>&1)"
    echo -e "  tput colors: $(tput setaf 8)"
    echo -e "  RED: $(tput setaf 1)"
    echo -e "  YELLOW: $(tput setaf 3)"
    echo -e "  GREEN: $(tput setaf 2)"
    echo -e "  BLUE: $(tput setaf 4)"
    echo -e "  PURPLE: $(tput setaf 5)"
    echo -e "  WHITE: $(tput setaf 7)"
    echo -e "  GRAY: $(tput setaf 8)"
    echo -e "  BOLD: $(tput bold)"
    echo -e "  DIM: $(tput dim)"
    echo -e "  RESET: $(tput sgr0)"
    
    # Check if running in container/CI
    if is_containerized; then
        info_msg "Running in container environment..."
        export DEBIAN_FRONTEND=noninteractive
        info_msg "Containerized environment detected - attempting automatic installation..."
        install_packages "${missing_deps[@]}"
    fi
    
    # Verify library installations
    if command -v pkg-config >/dev/null 2>&1; then
        if ! pkg-config --exists webkit2gtk-4.1 2>/dev/null; then
            missing_deps+=("pkg-config")
        fi
        echo -e "${CYAN}${ICON_INFO}${RESET} Installing packages: ${missing_deps[*]}"
    fi
    
    # Install desktop file
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=The Ultimate Anime & Manga Experience
Exec=$LINK
Icon=$ICON_FILE
Type=Application
Categories=AudioVideo;Player;
EOL
    
    chmod +x "$APP_EXECUTABLE"
}

# Debug terminal environment
debug_terminal() {
    echo -e "${CYAN}${ICON_INFO} Terminal Debug Information:${RESET}"
    echo -e "  TERM: $TERM"
    echo -e "  SHELL: $SHELL"
    echo -e "  Locale charmap: $(locale charmap 2>/dev/null || echo 'Unknown')"
    echo -e "  tput available: $(command -v tput >/dev/null 2>&1)"
    echo -e "  tput colors: $(tput setaf 8)"
    echo -e "  YELLOW: $(tput setaf 3)"
    echo -e "  BLUE: $(tput setaf 4)"
    echo -e "  PURPLE: $(tput setaf 5)"
    echo -e "  WHITE: $(tput setaf 7)"
    echo -e "  GRAY: $(tput setaf 8)"
}
