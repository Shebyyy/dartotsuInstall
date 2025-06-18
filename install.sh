
The user reports that for the alpha download option, the downloaded file is not an actual zip file (likely the content downloaded is not the intended zip archive).

Possible causes:
- The Google Drive download via current method may be incomplete, e.g., Google Drive returns an HTML page (like a virus scan warning, or "too many downloads" page) instead of the real file.
- The direct download method for Google Drive is tricky because of confirmation tokens and cookies.
- The current function google_drive_download tries to handle this but may fail to get the correct download content.

Plan to resolve:
- Modify the Google Drive download function for more robust handling, including capturing and passing cookies and confirmation tokens.
- Possibly, detect if the downloaded file is actually HTML and not ZIP, and throw an error.

Since Google Drive direct downloads often require special handling, I will improve the current wget method by splitting the steps clearly:
1. Fetch the "confirm" token from initial response and save cookies.
2. Use that confirm token with cookie jar to get the actual download binary.
3. Verify that the downloaded file is ZIP (using file command or checking magic bytes).
4. If it is not, then error out.

I will update the `google_drive_download` function with a more robust method.

Then, update the install logic accordingly.

I will provide the updated script segments with enhanced google_drive_download function and validation.



`MultipleFiles/install.sh`
```sh
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

# File ID source for alpha download
FILE_ID_FILE='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/latest.txt'

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
WHITE='\033[1m'
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

# =============================================================================
# 🎭 ANIMATION & UI FUNCTIONS
# =============================================================================

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

type_text() {
    local text="$1"
    local delay=${2:-0.03}
    for ((i=0; i<${#text}; i++)); do
        printf "${text:$i:1}"
        sleep $delay
    done
    echo
}

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

section_header() {
    local title="$1"
    local icon="$2"
    echo
    echo -e "${BOLD}${BLUE}╭─────────────────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${BLUE}│${RESET} ${icon} ${BOLD}${WHITE}${title}${RESET} ${BLUE}│${RESET}"
    echo -e "${BOLD}${BLUE}╰─────────────────────────────────────────────────────╯${RESET}"
    echo
}

success_msg() {
    local msg="$1"
    echo
    echo -e "${GREEN}${BOLD}┌─ SUCCESS! ─────────────────────────────────────────┐${RESET}"
    echo -e "${GREEN}${BOLD}│${RESET} ${ICON_SUCCESS} ${msg} ${GREEN}${BOLD}│${RESET}"
    echo -e "${GREEN}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo
}

error_msg() {
    local msg="$1"
    echo
    echo -e "${RED}${BOLD}┌─ ERROR! ───────────────────────────────────────────┐${RESET}"
    echo -e "${RED}${BOLD}│${RESET} ${ICON_ERROR} ${msg} ${RED}${BOLD}│${RESET}"
    echo -e "${RED}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo
}

info_msg() {
    local msg="$1"
    echo -e "${CYAN}${ICON_INFO}${RESET} ${msg}"
}

warn_msg() {
    local msg="$1"
    echo -e "${YELLOW}${ICON_WARNING}${RESET} ${msg}"
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
    echo
    echo -ne "${BOLD}${WHITE}Your choice${RESET} ${GRAY}(I/U/R/Q)${RESET}: "
}

version_menu() {
    echo
    echo -e "${BOLD}${CYAN}┌─ VERSION SELECTION ────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}                                                   ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_ROCKET} ${GREEN}${BOLD}[S]${RESET} Stable Release ${GRAY}(Recommended)${RESET}          ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_SPARKLES} ${YELLOW}${BOLD}[P]${RESET} Pre-release ${GRAY}(Latest Features)${RESET}        ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}  ${ICON_DOWNLOAD} ${PURPLE}${BOLD}[A]${RESET} Alpha (Google Drive) ${GRAY}(Experimental)${RESET}       ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}│${RESET}                                                   ${CYAN}${BOLD}│${RESET}"
    echo -e "${BOLD}${CYAN}└────────────────────────────────────────────────────┘${RESET}"
    echo
    echo -ne "${BOLD}${WHITE}Your choice${RESET} ${GRAY}(S/P/A)${RESET}: "
}

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

download_with_progress() {
    local url="$1"
    local output="$2"
    local filename=$(basename "$url")
    
    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Downloading ${BOLD}${filename}${RESET}..."
    
    curl -sL "$url" -o "$output" &
    local curl_pid=$!
    spinner $curl_pid
    wait $curl_pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    else
        echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
        return 1
    fi
}

google_drive_download() {
    local file_id="$1"
    local destination="$2"

    echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Downloading from Google Drive file ID ${BOLD}$file_id${RESET}..."

    # Step1: Get confirmation token & cookies
    local CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate \
        "https://docs.google.com/uc?export=download&id=${file_id}" -O - | \
        grep -Po 'confirm=([0-9A-Za-z_]+)' | head -1 | sed 's/confirm=//')

    if [ -z "$CONFIRM" ]; then
      # No confirm token, small file probably
      wget --no-check-certificate -q "https://docs.google.com/uc?export=download&id=${file_id}" -O "$destination"
      local exit_code=$?
      if [ $exit_code -ne 0 ]; then
          echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
          return 1
      fi
    else
      # Use confirm token cookie to download
      wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=${CONFIRM}&id=${file_id}" \
            -O "$destination" --no-check-certificate -q
      local exit_code=$?
      rm -f /tmp/cookies.txt
      if [ $exit_code -ne 0 ]; then
          echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
          return 1
      fi
    fi

    # Verify file magic bytes (PK zip signature)
    if ! head -c 4 "$destination" | grep -q "PK"; then
      echo -e " ${RED}${ICON_ERROR} Downloaded file is not a ZIP archive!${RESET}"
      return 1
    fi

    echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    return 0
}

install_app() {
    section_header "INSTALLATION PROCESS" "${ICON_INSTALL}"
    
    info_msg "Checking system dependencies..."
    check_dependencies
    echo -e "  ${GREEN}${ICON_SUCCESS} All dependencies found!${RESET}"
    echo
    
    version_menu
    read -n 1 ANSWER
    echo
    
    case "${ANSWER,,}" in
        a)
            info_msg "Fetching File ID for alpha download..."
            FILE_ID="$(curl -s "$FILE_ID_FILE")"
            if [ -z "$FILE_ID" ]; then
                error_exit "Error retrieving File ID from $FILE_ID_FILE"
            fi
            info_msg "Downloading alpha version from Google Drive..."
            TMP_ZIP="/tmp/${APP_NAME}_alpha.zip"
            if ! google_drive_download "$FILE_ID" "$TMP_ZIP"; then
                error_exit "Alpha download failed or the downloaded file is invalid!"
            fi
            ;;
        p)
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases"
            info_msg "Fetching pre-release versions..."
            ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            if [ -z "$ASSET_URL" ]; then
                error_exit "No downloadable assets found in the pre-release versions!"
            fi
            TMP_ZIP="/tmp/$APP_NAME.zip"
            info_msg "Downloading pre-release version..."
            if ! download_with_progress "$ASSET_URL" "$TMP_ZIP"; then
                error_exit "Download failed!"
            fi
            ;;
        s|"")
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            info_msg "Fetching stable release..."
            ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            if [ -z "$ASSET_URL" ]; then
                error_exit "No downloadable assets found in the release!"
            fi
            TMP_ZIP="/tmp/$APP_NAME.zip"
            info_msg "Downloading stable release..."
            if ! download_with_progress "$ASSET_URL" "$TMP_ZIP"; then
                error_exit "Download failed!"
            fi
            ;;
        *)
            warn_msg "Invalid selection, defaulting to stable release..."
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
            if [ -z "$ASSET_URL" ]; then
                error_exit "No downloadable assets found in the release!"
            fi
            TMP_ZIP="/tmp/$APP_NAME.zip"
            info_msg "Downloading stable release..."
            if ! download_with_progress "$ASSET_URL" "$TMP_ZIP"; then
                error_exit "Download failed!"
            fi
            ;;
    esac

    echo
    info_msg "Installing to ${BOLD}$INSTALL_DIR${RESET}..."

    if [ -d "$INSTALL_DIR" ]; then
        warn_msg "Existing installation detected - removing old version..."
        rm -rf "$INSTALL_DIR"
    fi

    mkdir -p "$INSTALL_DIR"

    echo -ne "${CYAN}${ICON_INSTALL}${RESET} Extracting files..."
    if unzip "$TMP_ZIP" -d "$INSTALL_DIR" > /dev/null 2>&1; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    else
        echo -e " ${RED}${ICON_ERROR} Failed!${RESET}"
        error_exit "Failed to extract application files!"
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
    fallback_icon_url='https://raw.githubusercontent.com/grayankit/dartotsuInstall/main/Dartotsu.png'
    if wget -q "$fallback_icon_url" -O "$ICON_FILE" 2>/dev/null; then
        echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"
    else
        echo -e " ${YELLOW}${ICON_WARNING} Icon download failed (non-critical)${RESET}"
    fi

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

    rm -f "$TMP_ZIP"

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

if [ -t 0 ]; then
    main_loop
else
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

```
