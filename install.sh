#!/bin/bash
set -e

# =============================================================================
# 🎯 DARTOTSU ALPHA INSTALLER
# This script installs the latest experimental Alpha build from Google Drive.
# =============================================================================

# --- Configuration ---
APP_NAME="Dartotsu"
FILE_ID_FILE='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/latest.txt'
ICON_URL='https://raw.githubusercontent.com/grayankit/dartotsuInstall/main/Dartotsu.png'

# --- Installation Paths ---
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
LINK="$HOME/.local/bin/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
ICON_FILE="$HOME/.local/share/icons/$APP_NAME.png"

# =============================================================================
# 🎨 COLORS & ICONS (Keep the cool look!)
# =============================================================================
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m';
PURPLE='\033[0;35m'; CYAN='\033[0;36m'; WHITE='\033[1;37m'; GRAY='\033[0;90m';
BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m';
GRAD1='\033[38;5;198m'; GRAD2='\033[38;5;199m'; GRAD3='\033[38;5;200m';
GRAD4='\033[38;5;135m'; GRAD5='\033[38;5;99m'; GRAD6='\033[38;5;63m';
ICON_SUCCESS="✅"; ICON_ERROR="❌"; ICON_INFO="ℹ️ "; ICON_DOWNLOAD="⬇️ ";
ICON_INSTALL="📦"; ICON_FLASK="🧪";

# =============================================================================
# 🎭 UI & HELPER FUNCTIONS
# =============================================================================

# --- Spinner Animation ---
spinner() {
    local pid=$1; local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while ps -p "$pid" > /dev/null; do
        local temp=${spinstr#?}; printf " [${CYAN}%c${RESET}]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}; sleep 0.1; printf "\b\b\b\b\b\b"
    done; printf "    \b\b\b\b"
}

# --- Messaging ---
info_msg() { echo -e "${CYAN}${ICON_INFO}${RESET} $1"; }
error_exit() {
    echo; echo -e "${RED}${BOLD}┌─ ERROR! ───────────────────────────────────────────┐${RESET}"
    printf "${RED}${BOLD}│${RESET} ${ICON_ERROR} %-49s ${RED}${BOLD}│${RESET}\n" "$1"
    echo -e "${RED}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo; echo -e "${GRAY}${DIM}Press any key to exit...${RESET}"; read -n 1; exit 1
}

# --- Dependency Check ---
check_dependencies() {
    info_msg "Checking for required tools: curl, unzip, yt-dlp..."
    local missing_deps=()
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v unzip >/dev/null 2>&1 || missing_deps+=("unzip")
    command -v yt-dlp >/dev/null 2>&1 || missing_deps+=("yt-dlp")
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        error_exit "Missing: ${missing_deps[*]}. Install yt-dlp with 'pip install -U yt-dlp'"
    fi
    echo -e "  ${GREEN}${ICON_SUCCESS} All tools found!${RESET}"
}

# =============================================================================
# 🚀 MAIN INSTALLATION LOGIC
# =============================================================================

# --- Show the Banner ---
clear; echo
echo -e "${GRAD1}  ██████╗  █████╗ ██████╗ ████████╗ ██████╗ ████████╗███████╗██╗   ██╗${RESET}"
echo -e "${GRAD2}  ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗╚══██╔══╝██╔════╝██║   ██║${RESET}"
echo -e "${GRAD3}  ██║  ██║███████║██████╔╝   ██║   ██║   ██║   ██║   ███████╗██║   ██║${RESET}"
echo -e "${GRAD4}  ██║  ██║██╔══██║██╔══██╗   ██║   ██║   ██║   ██║   ╚════██║██║   ██║${RESET}"
echo -e "${GRAD5}  ██████╔╝██║  ██║██║  ██║   ██║   ╚██████╔╝   ██║   ███████║╚██████╔╝${RESET}"
echo -e "${GRAD6}  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝ ${RESET}"
echo; echo -e "${CYAN}${BOLD}                    ALPHA BUILD INSTALLER${RESET}"
echo -e "${GRAY}                    ═══════════════════════════════════════${RESET}"; echo

# --- Step 1: Check Dependencies ---
check_dependencies

# --- Step 2: Get File ID ---
info_msg "Fetching latest Alpha build information..."
FILE_ID=$(curl -s --fail "$FILE_ID_FILE")
if [ -z "$FILE_ID" ]; then error_exit "Could not retrieve the Alpha build File ID."; fi
info_msg "Found Alpha build with File ID: ${BOLD}${FILE_ID}${RESET}"

# --- Step 3: Download the File using yt-dlp ---
DOWNLOAD_FILENAME="$APP_NAME-alpha.zip"
DOWNLOAD_PATH="/tmp/$DOWNLOAD_FILENAME"
GDRIVE_URL="https://drive.google.com/file/d/$FILE_ID/view"

(
    # Run yt-dlp in a subshell to capture PID
    yt-dlp --quiet --no-warnings --no-check-certificate -o "$DOWNLOAD_PATH" "$GDRIVE_URL"
) &
DOWNLOAD_PID=$!

echo -ne "${CYAN}${ICON_DOWNLOAD}${RESET} Downloading ${BOLD}${DOWNLOAD_FILENAME}${RESET} via yt-dlp..."
spinner $DOWNLOAD_PID
wait $DOWNLOAD_PID || error_exit "Download failed! Please check your connection."
echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"

# --- Step 4: Verify and Install ---
info_msg "Installing to ${BOLD}$INSTALL_DIR${RESET}..."
if [ -d "$INSTALL_DIR" ]; then echo -e "${YELLOW}  - Removing existing installation...${RESET}"; rm -rf "$INSTALL_DIR"; fi
mkdir -p "$INSTALL_DIR"

echo -ne "${CYAN}${ICON_INSTALL}${RESET} Verifying and extracting archive..."
if ! unzip -t "$DOWNLOAD_PATH" > /dev/null 2>&1; then
    error_exit "Download is corrupted or not a valid zip file."
fi
unzip -o "$DOWNLOAD_PATH" -d "$INSTALL_DIR" > /dev/null 2>&1
echo -e " ${GREEN}${ICON_SUCCESS} Done!${RESET}"

# --- Step 5: Set up Executable and Links ---
info_msg "Setting up application..."
APP_EXECUTABLE=$(find "$INSTALL_DIR" -type f \( -perm /u+x -o -name "*.AppImage" -o -name "$APP_NAME" \) -print -quit)
if [ -z "$APP_EXECUTABLE" ]; then error_exit "Could not find an executable in the archive!"; fi
chmod +x "$APP_EXECUTABLE"
echo "  - Found executable: ${DIM}$(basename "$APP_EXECUTABLE")${RESET}"

mkdir -p "$HOME/.local/bin"
ln -sf "$APP_EXECUTABLE" "$LINK"
echo "  - Symlink created at ${DIM}$LINK${RESET}"

# --- Step 6: Create Desktop Entry and Icon ---
info_msg "Creating desktop entry..."
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

# Silently try to download the icon and update the database
mkdir -p "$(dirname "$ICON_FILE")"
curl -sL "$ICON_URL" -o "$ICON_FILE" &
if command -v update-desktop-database >/dev/null 2>&1; then update-desktop-database "$HOME/.local/share/applications" 2>/dev/null; fi

# --- Step 7: Cleanup ---
rm -f "$DOWNLOAD_PATH"

# --- All Done! ---
echo
echo -e "${GREEN}${BOLD}┌─ SUCCESS! ─────────────────────────────────────────┐${RESET}"
echo -e "${GREEN}${BOLD}│${RESET} ${ICON_FLASK} Dartotsu Alpha has been installed!             ${GREEN}${BOLD}│${RESET}"
echo -e "${GREEN}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
echo
info_msg "Launch it from your applications menu or run: ${BOLD}$APP_NAME${RESET}"
echo
