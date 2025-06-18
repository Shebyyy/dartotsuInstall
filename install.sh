#!/bin/bash
set -e

APP_NAME="Dartotsu"
FILE_ID="1A4w-TaswP1ao9E6ahXMJz3Z3g6qVBJDg"
OUTPUT_ZIP="/tmp/${APP_NAME}.zip"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
COOKIES="/tmp/gdrive_cookies.txt"

# STEP 1: Get confirm token
echo "📡 Getting confirmation token..."
CONFIRM=$(wget --quiet --save-cookies "$COOKIES" --keep-session-cookies --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O - | \
  sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')

if [ -z "$CONFIRM" ]; then
  echo "❌ Failed to get confirmation token"
  exit 1
fi

# STEP 2: Download the actual file
FINAL_URL="https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}"
echo "⬇️ Downloading $APP_NAME..."
wget --load-cookies "$COOKIES" "$FINAL_URL" -O "$OUTPUT_ZIP" || {
  echo "❌ Download failed"
  exit 1
}
rm -f "$COOKIES"

# STEP 3: Verify and extract
echo "🧪 Verifying ZIP..."
if ! unzip -t "$OUTPUT_ZIP" > /dev/null 2>&1; then
  echo "❌ Invalid ZIP file"
  exit 1
fi

echo "📦 Extracting to $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -o "$OUTPUT_ZIP" -d "$INSTALL_DIR" > /dev/null

echo "✅ Installed $APP_NAME to $INSTALL_DIR"
