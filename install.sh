#!/bin/bash
set -e

APP_NAME="Dartotsu"
DIRECT_URL="https://drive.usercontent.google.com/download?id=1A4w-TaswP1ao9E6ahXMJz3Z3g6qVBJDg&export=download"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
OUTPUT_ZIP="/tmp/${APP_NAME}-alpha.zip"

# === Download ===
echo "⬇️ Downloading from Google Drive..."
wget -q --show-progress -O "$OUTPUT_ZIP" "$DIRECT_URL" || {
    echo "❌ Download failed!"
    exit 1
}

# === Verify ===
echo "🧪 Verifying ZIP file..."
file "$OUTPUT_ZIP"
if ! unzip -t "$OUTPUT_ZIP" > /dev/null 2>&1; then
    echo "❌ Invalid ZIP file!"
    exit 1
fi

# === Extract ===
echo "📦 Extracting to $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -o "$OUTPUT_ZIP" -d "$INSTALL_DIR" > /dev/null

echo "✅ $APP_NAME installed successfully at $INSTALL_DIR"
