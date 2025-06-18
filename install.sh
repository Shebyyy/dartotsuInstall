#!/bin/bash
set -e

APP_NAME="Dartotsu"
DIRECT_URL="https://drive.usercontent.google.com/download?id=1A4w-TaswP1ao9E6ahXMJz3Z3g6qVBJDg&export=download"
OUTPUT_ZIP="/tmp/${APP_NAME}.zip"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"

echo "⬇️ Downloading $APP_NAME..."
wget -q --show-progress -O "$OUTPUT_ZIP" "$DIRECT_URL" || {
  echo "❌ Download failed!"
  exit 1
}

echo "🧪 Verifying downloaded ZIP..."
if ! unzip -t "$OUTPUT_ZIP" > /dev/null 2>&1; then
  echo "❌ Invalid ZIP file!"
  file "$OUTPUT_ZIP"
  exit 1
fi

echo "📦 Extracting to $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -o "$OUTPUT_ZIP" -d "$INSTALL_DIR" > /dev/null

echo "✅ $APP_NAME installed successfully to $INSTALL_DIR"
