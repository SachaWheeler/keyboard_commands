#!/bin/bash

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg could not be found. Please install it and try again."
    exit 1
fi

# Convert all .m4a files in the current directory to .mp3 with 320k bitrate
for file in *.m4a; do
    if [[ -f "$file" ]]; then
        # Get the base name of the file without extension
        base_name="${file%.m4a}"
        # Convert to mp3
        ffmpeg -i "$file" -vn -ar 44100 -ac 2 -b:a 320k -map_metadata 0 -id3v2_version 3 "${base_name}.mp3"
        echo "Converted: $file to ${base_name}.mp3"
    fi
done

