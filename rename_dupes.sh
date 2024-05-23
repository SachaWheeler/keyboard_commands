#!/bin/bash

# Check if a directory name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

root_dir="$1"

# Find and rename all files ending with " 1.mp3"
find "$root_dir" -type f -name "* 1.mp3" | while read -r file; do
    newfile="${file// 1.mp3/.mp3}"
    mv "$file" "$newfile"
    echo "Renamed: $file to $newfile"
done

