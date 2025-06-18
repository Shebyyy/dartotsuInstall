#!/bin/bash
set -e

# === CONFIG ===
APP_NAME="Dartotsu"
FILE_ID_FILE='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/latest.txt'
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
OUTPUT_ZIP="/tmp/${APP_NAME}-alpha.zip"
COOKIES="/tmp/gdrive_cookies.txt"

# === FETCH FILE ID ===
echo "📡 Fetching File ID..."
FILE_ID="$(curl -s "$FILE_ID_FILE")"
if [ -z "$FILE_ID" ]; then
  echo "❌ Failed to get File ID from $FILE_ID_FILE"
  exit 1
fi

# === CONFIRM TOKEN ===
echo "📡 Getting confirmation token from Google Drive..."
CONFIRM=$(wget --quiet --save-cookies "$COOKIES" --keep-session-cookies --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O - | \
  sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')

# === DOWNLOAD ===
echo "⬇️ Downloading $APP_NAME Alpha..."
wget --load-cookies "$COOKIES" "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" \
  -O "$OUTPUT_ZIP" || { echo "❌ Download failed!"; exit 1; }
rm -f "$COOKIES"

# === VERIFY ZIP ===
echo "🧪 Verifying ZIP..."
file "$OUTPUT_ZIP"
if ! unzip -t "$OUTPUT_ZIP" > /dev/null 2>&1; then
  echo "❌ Invalid ZIP file!"
  exit 1
fi

# === EXTRACT ===
echo "📦 Extracting to $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -o "$OUTPUT_ZIP" -d "$INSTALL_DIR" > /dev/null

echo "✅ $APP_NAME Alpha installed to $INSTALL_DIR"
