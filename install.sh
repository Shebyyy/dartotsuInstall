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

# Gradient colors
GRAD1='\033[38;5;198m'  # Hot pink
GRAD2='\033[38;5;199m'  # Pink
GRAD3='\033[38;5;200m'  # Light pink
GRAD4='\033[38;5;135m'  # Purple
GRAD5='\033[38;5;99m'   # Dark purple
GRAD6='\033[38;5;63m'   # Blue purple

# Icons
ICON_SUCCESS="✅"
ICON_ERROR="❌"
ICON_WARNING="⚠️ "
ICON_INFO="ℹ️ "
ICON_ROCKET="🚀"
ICON_DOWNLOAD="⬇️ "
ICON_INSTALL="📦"
ICON_UNINSTALL="🗑️ "
ICON_UPDATE="🔄"
ICON_SPARKLES="✨"
ICON_FLASK="🧪"

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
    
    printf "\r${BOLD}Progress: ${RESET}["
    printf "${GREEN}%*s${RESET}" $filled | tr ' ' '█'
    printf "%*s" $empty | tr ' ' '░'
    printf "] ${BOLD}%d%%${RESET}" $percentage
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
    echo -e "${GRAD1}  ██████╗  █████╗ ██████╗ ████████╗ ██████╗ ████████╗███████╗██╗   ██╗${RESET}"
    echo -e "${GRAD2}  ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗╚══██╔══╝██╔════╝██║   ██║${RESET}"
    echo -e "${GRAD3}  ██║  ██║███████║██████╔╝   ██║   ██║   ██║   ██║   ███████╗██║   ██║${RESET}"
    echo -e "${GRAD4}  ██║  ██║██╔══██║██╔══██╗   ██║   ██║   ██║   ██║   ╚════██║██║   ██║${RESET}"
    echo -e "${GRAD5}  ██████╔╝██║  ██║██║  ██║   ██║   ╚██████╔╝   ██║   ███████║╚██████╔╝${RESET}"
    echo -e "${GRAD6}  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝ ${RESET}"
    echo
    echo -e "${CYAN}${BOLD}                    The Ultimate Anime & Manga Experience${RESET}"
    echo -e "${GRAY}                    ═══════════════════════════════════════${RESET}"
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

# Success message with animation
success_msg() {
    local msg="$1"
    echo
    echo -e "${GREEN}${BOLD}┌─ SUCCESS! ─────────────────────────────────────────┐${RESET}"
    echo -e "${GREEN}${BOLD}│${RESET} ${ICON_SUCCESS} ${msg} ${GREEN}${BOLD}│${RESET}"
    echo -e "${GREEN}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo
}

# Error message
error_msg() {
    local msg="$1"
    echo
    echo -e "${RED}${BOLD}┌─ ERROR! ───────────────────────────────────────────┐${RESET}"
    echo -e "${RED}${BOLD}│${RESET} ${ICON_ERROR} ${msg} ${RED}${BOLD}│${RESET}"
    echo -e "${RED}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
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

# Stylized menu
show_menu() {
    echo -e "${BOLD}${PURPLE}┌─ SELECT ACTION ────────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}                                                   ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}  ${ICON_INSTALL} ${GREEN}${BOLD}[I]${RESET} Install Dartotsu                      ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}  ${ICON_UPDATE} ${YELLOW}${BOLD}[U]${RESET} Update Dartotsu                       ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}  ${ICON_UNINSTALL} ${RED}${BOLD}[R]${RESET} Remove Dartotsu                       ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}  ${ICON_SPARKLES} ${CYAN}${BOLD}[Q]${RESET} Quit                                  ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}│${RESET}                                                   ${PURPLE}${BOLD}│${RESET}"
    echo -e "${BOLD}${PURPLE}└────────────────────────────────────────────────────┘${RESET}"
    echo
    echo -ne "${BOLD}${WHITE}Your choice${RESET} ${GRAY}(I/U/R/Q)${RESET}: "
}

# Version selection menu
version_menu() {
    echo
    echo -e "${BOLD}${CYAN}┌─ VERSION SELECTION ────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}                                                   ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_ROCKET} ${GREEN}${BOLD}[S]${RESET} Stable Release ${GRAY}(Recommended)${RESET}          ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_SPARKLES} ${YELLOW}${BOLD}[P]${RESET} Pre-release ${GRAY}(Latest Features)${RESET}        ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_FLASK} ${BLUE}${BOLD}[A]${RESET} Alpha Build ${GRAY}(Experimental)${RESET}          ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}                                                   ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}└────────────────────────────────────────────────────┘${RESET}"
    echo
    echo -ne "${BOLD}${WHITE}Your choice${RESET} ${GRAY}(S/P/A)${RESET}: "
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

check_dependencies() {
    local missing_deps=()
    
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v unzip >/dev/null 2>&1 || missing_deps+=("unzip")
    command -v wget >/dev/null 2>&1 || missing_deps+=("wget")
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        error_exit "Missing dependencies: ${missing_deps[*]}. Please install them first."
    fi
}

# Alternative Google Drive download using wget with specific user agent and session handling
download_gdrive_file() {
    local file_id="$1"
    local output="$2"
    local temp_cookies="/tmp/gdrive_cookies_$"
    
    # Clean up cookies file on exit
    trap "rm -f $temp_cookies" EXIT
    
    # First, try to get the download page and extract any confirmation tokens
    local confirm_url="https://drive.google.com/uc?export=download&id=${file_id}"
    
    # Use wget to handle the download with proper session management
    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Fetching download page..."
    
    # Get the initial page with cookies
    if wget --save-cookies="$temp_cookies" \
           --keep-session-cookies \
           --no-check-certificate \
           --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
           -q -O - "$confirm_url" > /tmp/gdrive_page_$ 2>/dev/null; then
        echo -e " ${GREEN}${ICON_SUCCESS}${RESET}"
    else
        echo -e " ${RED}${ICON_ERROR}${RESET}"
        rm -f "$temp_cookies" /tmp/gdrive_page_$
        return 1
    fi
    
    # Look for confirmation token or direct download
    local confirm_token=""
    if grep -q "confirm=" /tmp/gdrive_page_$; then
        confirm_token=$(grep -o 'confirm=[^&"]*' /tmp/gdrive_page_$ | head -1 | cut -d'=' -f2)
    fi
    
    # Build the final download URL
    local download_url
    if [ -n "$confirm_token" ]; then
        download_url="https://drive.google.com/uc?export=download&confirm=${confirm_token}&id=${file_id}"
    else
        download_url="$confirm_url"
    fi
    
    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Downloading file..."
    
    # Download the actual file
    if wget --load-cookies="$temp_cookies" \
           --no-check-certificate \
           --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
           --content-disposition \
           -q "$download_url" -O "$output"; then
        echo -e " ${GREEN}${ICON_SUCCESS}${RESET}"
        rm -f "$temp_cookies" /tmp/gdrive_page_$
        return 0
    else
        echo -e " ${RED}${ICON_ERROR}${RESET}"
        rm -f "$temp_cookies" /tmp/gdrive_page_$
        return 1
    fi
}

download_with_progress() {
    local url="$1"
    local output="$2"
    local filename
    
    # Use descriptive filename for alpha builds
    if [[ "$url" == *"drive.google.com"* ]]; then
        filename="$APP_NAME-alpha.zip"
        
        # Extract file ID from Google Drive URL
        local file_id=$(echo "$url" | sed -n 's/.*id=\([^&]*\).*/\1/p')
        
        if [ -n "$file_id" ]; then
            echo -e "${CYAN}${ICON_INFO}${RESET} Using specialized Google Drive downloader..."
            if download_gdrive_file "$file_id" "$output"; then
                echo -e "${GREEN}${ICON_SUCCESS}${RESET} Google Drive download completed!"
                return 0
            else
                echo -e "${RED}${ICON_ERROR}${RESET} Google Drive download failed!"
                return 1
            fi
        else
            echo -e "${RED}${ICON_ERROR}${RESET} Could not extract file ID from Google Drive URL!"
            return 1
        fi
    else
        filename=$(basename "$url")
        echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Downloading ${BOLD}${filename}${RESET}..."
        
        # Regular download for non-Google Drive URLs
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
    fi
}

install_app() {
    section_header "INSTALLATION PROCESS" "${ICON_INSTALL}"
    
    # Check dependencies
    info_msg "Checking system dependencies..."
    check_dependencies
    echo -e "  ${GREEN}${ICON_SUCCESS} All dependencies found!${RESET}"
    echo
    
    # Version selection
    version_menu
    read -n 1 ANSWER
    echo
    
    # Default to stable if no asset URL is found
    ASSET_URL=""
    DOWNLOAD_FILENAME="$APP_NAME.zip"
    
    case "${ANSWER,,}" in
        p)
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases"
            info_msg "Fetching pre-release versions..."
            ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            ;;
        a)
            info_msg "Fetching alpha build info..."
            local FILE_ID_FILE='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/latest.txt'
            local FILE_ID
            FILE_ID="$(curl -s "$FILE_ID_FILE")"
            if [ -z "$FILE_ID" ]; then
                error_exit "Failed to retrieve File ID from $FILE_ID_FILE"
            fi
            info_msg "Found Alpha build with File ID: ${BOLD}${FILE_ID}${RESET}"
            
            # Try multiple Google Drive download URLs
            ASSET_URL="https://drive.google.com/uc?export=download&id=${FILE_ID}"
            DOWNLOAD_FILENAME="$APP_NAME-alpha.zip"
            
            # Store file ID for potential alternative download methods
            ALPHA_FILE_ID="$FILE_ID"
            ;;
        s|"")
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            info_msg "Fetching stable release..."
            ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            ;;
        *)
            warn_msg "Invalid selection, defaulting to stable release..."
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            ;;
    esac
    
    if [ -z "$ASSET_URL" ]; then
        error_exit "No downloadable assets found for the selected version!"
    fi
    
    # Download
    echo
    if ! download_with_progress "$ASSET_URL" "/tmp/$DOWNLOAD_FILENAME"; then
        # If Google Drive download failed and we have a file ID, try alternative methods
        if [ -n "$ALPHA_FILE_ID" ]; then
            warn_msg "Primary download failed, trying alternative methods..."
            
            # Try yt-dlp if available (it can handle Google Drive)
            if command -v yt-dlp >/dev/null 2>&1; then
                info_msg "Attempting download with yt-dlp..."
                if yt-dlp -o "/tmp/$DOWNLOAD_FILENAME" "https://drive.google.com/file/d/${ALPHA_FILE_ID}/view" 2>/dev/null; then
                    success_msg "Alternative download method succeeded!"
                else
                    error_exit "All download methods failed. Please try again later or use a different version."
                fi
            else
                error_exit "Download failed! Consider installing yt-dlp for better Google Drive support: pip install yt-dlp"
            fi
        else
            error_exit "Download failed!"
        fi
    fi
    
    # Installation
    echo
    info_msg "Installing to ${BOLD}$INSTALL_DIR${RESET}..."
    
    if [ -d "$INSTALL_DIR" ]; then
        warn_msg "Existing installation detected - removing old version..."
        rm -rf "$INSTALL_DIR"
    fi
    
    mkdir -p "$INSTALL_DIR"
    
    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Extracting files..."
    
    # Verify the zip file before extraction
    if ! unzip -t "/tmp/$DOWNLOAD_FILENAME" > /dev/null 2>&1; then
        echo -e " ${RED}${ICON_ERROR} Invalid zip file!${RESET}"
        info_msg "File info: $(file "/tmp/$DOWNLOAD_FILENAME")"
        error_exit "Downloaded file is corrupted or not a valid zip archive!"
    fi
    
    if unzip -o "/tmp/$DOWNLOAD_FILENAME" -d "$INSTALL_DIR" > /dev/null 2>&1; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    else
        echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
        info_msg "Zip file contents:"
        unzip -l "/tmp/$DOWNLOAD_FILENAME" 2>/dev/null || echo "  Unable to list zip contents"
        error_exit "Failed to extract application files!"
    fi
    
    # Find executable
    APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f -executable -print -quit)"
    if [ -z "$APP_EXECUTABLE" ]; then
        error_exit "No executable found in the extracted files!"
    fi
    
    chmod +x "$APP_EXECUTABLE"
    
    # Create symlink
    mkdir -p "$HOME/.local/bin"
    ln -sf "$APP_EXECUTABLE" "$LINK"
    
    # Install icon
    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Installing icon..."
    mkdir -p "$(dirname "$ICON_FILE")"
    fallback_icon_url='https://raw.githubusercontent.com/grayankit/dartotsuInstall/main/Dartotsu.png'
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
    
    # Cleanup
    rm -f "/tmp/$DOWNLOAD_FILENAME"
    
    echo
    success_msg "$APP_NAME has been installed successfully!"
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
if [ -t 0 ]; then
    main_loop
else
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
fi
