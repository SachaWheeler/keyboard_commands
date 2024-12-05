#!/bin/bash

# Define the Media directory
MEDIA_DIR="/moshpit/porn"

# Define a temporary directory
TEMP_DIR="/tmp/yt-dlp-downloads"

# Ensure the Media directory exists
mkdir -p "$MEDIA_DIR"

# Ensure the temporary directory exists
mkdir -p "$TEMP_DIR"

# Check if a URL is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

URL="$1"

# Generate the output filename using yt-dlp's template
OUTPUT_FILENAME=$(yt-dlp --get-filename -o "%(title)s.%(ext)s" "$URL" 2>/dev/null)

if [ -z "$OUTPUT_FILENAME" ]; then
  echo "Error: Unable to generate output filename for the given URL."
  exit 1
fi

# Check if the file already exists in the Media directory
if [ -e "$MEDIA_DIR/$OUTPUT_FILENAME" ]; then
  echo "File already downloaded: $MEDIA_DIR/$OUTPUT_FILENAME"
  exit 0
fi

# Download the file to the temporary directory
echo "Downloading to temporary directory..."
yt-dlp -o "$TEMP_DIR/%(title)s.%(ext)s" "$URL"

# Check if the download was successful
DOWNLOADED_FILE=$(find "$TEMP_DIR" -type f -name "$OUTPUT_FILENAME")
if [ -z "$DOWNLOADED_FILE" ]; then
  echo "Error: Download failed or file not found in temporary directory."
  exit 1
fi

# Move the downloaded file to the Media directory
echo "Moving downloaded file to $MEDIA_DIR..."
mv "$DOWNLOADED_FILE" "$MEDIA_DIR"

# Cleanup temporary directory
# echo "Cleaning up temporary files..."
# rm -f "$TEMP_DIR"/*

echo "Download complete: $MEDIA_DIR/$OUTPUT_FILENAME"
exit 0

