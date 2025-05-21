#!/bin/bash

# Check for input
if [ -z "$1" ]; then
  echo "Usage: $0 input.mp4"
  exit 1
fi

INPUT="$1"

# Check file exists
if [ ! -f "$INPUT" ]; then
  echo "File not found: $INPUT"
  exit 1
fi

# Create a temp output file
DIR=$(dirname "$INPUT")
BASENAME=$(basename "$INPUT" .mp4)
TEMPFILE="$DIR/${BASENAME}_temp.mp4"

# Run ffmpeg to downsample video to 1280px width
ffmpeg -i "$INPUT" -vf "scale=1280:-2" -c:a copy -y "$TEMPFILE"

# Check if ffmpeg succeeded
if [ $? -eq 0 ]; then
  mv "$TEMPFILE" "$INPUT"
  echo "Compressed and replaced: $INPUT"
else
  echo "Compression failed"
  rm -f "$TEMPFILE"
  exit 1
fi

