#!/bin/bash
set -e

APP_NAME="Dartotsu"
FILE_ID_FILE='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/latest.txt'
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
OUTPUT_ZIP="/tmp/${APP_NAME}-alpha.zip"
COOKIES="/tmp/gdrive_cookies.txt"

# === Get File ID ===
echo "📡 Fetching File ID..."
FILE_ID="$(curl -s "$FILE_ID_FILE")"
if [ -z "$FILE_ID" ]; then
  echo "❌ Failed to get File ID"
  exit 1
fi

# === Try to get confirm token ===
echo "📡 Checking download method..."
PAGE=$(wget --quiet --save-cookies "$COOKIES" --keep-session-cookies --no-check-certificate \
  "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O -)

CONFIRM=$(echo "$PAGE" | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')

if [ -n "$CONFIRM" ]; then
  echo "🔐 Confirmation required, downloading with token..."
  FINAL_URL="https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}"
else
  echo "🔓 No confirmation needed, downloading directly..."
  FINAL_URL="https://drive.google.com/uc?export=download&id=${FILE_ID}"
fi

# === Download ===
wget --load-cookies "$COOKIES" "$FINAL_URL" -O "$OUTPUT_ZIP" || {
  echo "❌ Download failed!"
  exit 1
}
rm -f "$COOKIES"

# === Verify and Extract ===
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

echo "✅ $APP_NAME Alpha installed at $INSTALL_DIR"
