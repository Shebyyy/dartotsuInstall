#!/bin/bash
set -e

URL="https://drive.usercontent.google.com/download?id=1A4w-TaswP1ao9E6ahXMJz3Z3g6qVBJDg&export=download"
OUTPUT="/tmp/Dartotsu_alpha.zip"

echo "⬇️ Downloading Dartotsu Alpha..."
wget -q --show-progress -O "$OUTPUT" "$URL" || {
  echo "❌ Download failed!"
  exit 1
}

echo "✅ Downloaded to $OUTPUT"
