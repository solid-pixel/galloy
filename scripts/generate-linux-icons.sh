#!/bin/bash

# Input image
ROOT=$(cd "$(dirname "$0")/.." && pwd)
INPUT="$ROOT/assets/logo.png"
IMAGE_NAME="io.github.solid_pixel.Galloy.png"

# Sizes to generate
SIZES=(16 24 32 48 64 96 128 256 512)

# Check if input file exists
if [ ! -f "$INPUT" ]; then
    echo "Error: $INPUT not found!"
    exit 1
fi

# Loop over sizes
for SIZE in "${SIZES[@]}"; do
    TARGET_DIR="$ROOT/assets/linux/icons/hicolor/${SIZE}x${SIZE}/apps"
    mkdir -p "$TARGET_DIR"
    magick "$INPUT" -resize "${SIZE}x${SIZE}" -strip PNG32:"$TARGET_DIR/$IMAGE_NAME"
    echo "Created: $TARGET_DIR/$IMAGE_NAME"
done

echo "✅ All linux icons resized and saved."
