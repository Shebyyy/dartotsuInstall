#! /bin/bash

set -e

# Define application details
OWNER='aayush2622'
REPO='Dartotsu'
APP_NAME='Dartotsu'

# Installation directory
INSTALL_DIR="$HOME/.local/share/$APP_NAME"

# Executable symlink
LINK="$HOME/.local/bin/$APP_NAME"

# .desktop file
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"

# Icon
ICON_FILE="$HOME/.local/share/icons/$APP_NAME.png"

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

error_exit(){
    echo "Error: $1"
    exit 1
}

install_app(){
    # Ask whether to include prereleases
    read -p "Download (s)table or (p)rerelease? [s/p] " ANSWER

    if [ "$ANSWER" == "p" ]; then
        API_URL="https://api.github.com/repos/$OWNER/$REPO/releases"
        echo "Fetching all releases including prereleases…" 
        ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
    else
        API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
        echo "Fetching the latest stable release…" 
        ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
    fi

    if [ -z "$ASSET_URL" ]; then
        error_exit "Unable to find a ZIP asset in the release."
    fi

    echo "Downloading from $ASSET_URL..."
    if ! curl -sL "$ASSET_URL" -o "/tmp/$APP_NAME.zip"; then
        error_exit "Failed to download $ASSET_URL"
    fi

    echo "Installing to $INSTALL_DIR..."
    if [ -d "$INSTALL_DIR" ]; then
        echo "Existing installation found. Removing first…" 
        rm -rf "$INSTALL_DIR"
    fi

    mkdir -p "$INSTALL_DIR"

    if ! unzip "/tmp/$APP_NAME.zip" -d "$INSTALL_DIR" > /dev/null; then
        error_exit "Failed to extract ZIP file."
    fi

    APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f -executable -print -quit)"

    if [ -z "$APP_EXECUTABLE" ]; then
        error_exit "Application not found after extraction."
    fi

    chmod +x "$APP_EXECUTABLE"

    mkdir -p "$HOME/.local/bin"

    ln -sf "$APP_EXECUTABLE" "$LINK"

    # fallback icon
    if [ ! -f "$ICON_FILE" ]; then
        echo "Downloading fallback icon…" 
        fallback_icon_url='https://raw.githubusercontent.com/grayankit/dartotsuInstall/main/Dartotsu.png'

        if ! wget -q "$fallback_icon_url" -O "$ICON_FILE"; then
            echo "Failed to download fallback icon from $fallback_icon_url"
        fi
    fi

    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=Start $APP_NAME
Exec=$LINK
Icon=$ICON_FILE
Type=Application
Categories=Utility;
EOL

    chmod +x "$DESKTOP_FILE"

    update-desktop-database "$HOME/.local/share/applications"

    echo "$APP_NAME installed successfully!"
}

uninstall_app(){
    echo "Uninstalling $APP_NAME..."

    [ -L "$LINK" ] && rm -f "$LINK"

    [ -d "$INSTALL_DIR" ] && rm -rf "$INSTALL_DIR"

    [ -f "$DESKTOP_FILE" ] && rm -f "$DESKTOP_FILE"

    [ -f "$ICON_FILE" ] && rm -f "$ICON_FILE"

    update-desktop-database "$HOME/.local/share/applications"

    echo "$APP_NAME uninstalled successfully!"
}

update_app(){
    echo "Updating $APP_NAME…"    

    install_app
}

# ------------------------------------------------------------------------------
# Main script
# ------------------------------------------------------------------------------

read -p "What would you like to do? (install/update/uninstall) " ACTION

if [ "$ACTION" == "install" ]; then
    install_app
elif [ "$ACTION" == "update" ]; then
    update_app
elif [ "$ACTION" == "uninstall" ]; then
    uninstall_app
elif [ -z "$ACTION" ]; then
    echo "No action provided. Please rerun with install, update, or uninstall."
    exit 1
else
    echo "Unknown action: $ACTION"
    echo "Please use: install, update, or uninstall."
    exit 1
fi

