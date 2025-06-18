#!/bin/bash
set -e

APP_NAME="Dartotsu"
FILE_ID_FILE='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/latest.txt'
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
OUTPUT_ZIP="/tmp/${APP_NAME}-alpha.zip"
COOKIES="/tmp/gdrive_cookies.txt"

# === Step 1: Get File ID ===
echo "📡 Fetching File ID..."
FILE_ID="$(curl -s "$FILE_ID_FILE")"
if [ -z "$FILE_ID" ]; then
  echo "❌ Failed to retrieve File ID!"
  exit 1
fi
echo "✅ File ID: $FILE_ID"

# === Step 2: Get confirm token ===
echo "🔐 Requesting confirm token..."
CONFIRM=$(wget --quiet --save-cookies "$COOKIES" --keep-session-cookies --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O - | \
  sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')

if [ -z "$CONFIRM" ]; then
  echo "❌ Could not retrieve confirmation token from Google Drive."
  exit 1
fi

# === Step 3: Download with token ===
echo "⬇️ Downloading $APP_NAME Alpha..."
wget --load-cookies "$COOKIES" \
  "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" \
  -O "$OUTPUT_ZIP" || { echo "❌ Download failed!"; exit 1; }
rm -f "$COOKIES"

# === Step 4: Verify & Extract ===
echo "🧪 Verifying ZIP..."
file "$OUTPUT_ZIP"
if ! unzip -t "$OUTPUT_ZIP" > /dev/null 2>&1; then
  echo "❌ Invalid ZIP file!"
  exit 1
fi

echo "📦 Extracting to $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -o "$OUTPUT_ZIP" -d "$INSTALL_DIR" > /dev/null

echo "✅ $APP_NAME Alpha installed successfully at $INSTALL_DIR"
