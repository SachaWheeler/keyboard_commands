#!/bin/bash

ROOT_DIR="/home/sacha/happy_share"
SOURCE_DIR="$ROOT_DIR/incoming"
DEST_DIR="$ROOT_DIR/Music"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Check if id3v2 command is available
if ! command -v id3v2 &> /dev/null; then
    echo "id3v2 could not be found, please install it first."
    exit 1
fi

# Process each mp3 file in the source directory
find "$SOURCE_DIR" -type f -name "*.mp3" | while read -r FILE; do
    # Extract ID3 tags
    ARTIST=$(id3v2 -R "$FILE" | grep "TPE1" | cut -d ':' -f 2 | xargs)
    ALBUM=$(id3v2 -R "$FILE" | grep "TALB" | cut -d ':' -f 2 | xargs)
    TRACK=$(id3v2 -R "$FILE" | grep "TRCK" | cut -d ':' -f 2 | xargs)
    TITLE=$(id3v2 -R "$FILE" | grep "TIT2" | cut -d ':' -f 2 | xargs)

    # Check if any tag is missing and handle it (e.g., skip the file)
    if [ -z "$ARTIST" ] || [ -z "$ALBUM" ] || [ -z "$TRACK" ] || [ -z "$TITLE" ]; then
        echo "Skipping $FILE due to missing tags"
        echo "artist - $ARTIST"
        echo "album - $ALBUM"
        echo "track - $TRACK"
        echo "title - $TITLE"
        continue
    fi

    # Create the destination path
    DEST_PATH="$DEST_DIR/$ARTIST/$ALBUM"
    mkdir -p "$DEST_PATH"

    # Move the file to the new location
    NEW_FILE="$DEST_PATH/$TRACK $TITLE.mp3"
    # mv "$FILE" "$NEW_FILE"
    echo "Moved: $FILE -> $NEW_FILE"
done

echo "All files processed."

