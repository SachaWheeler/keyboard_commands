#!/bin/bash

echo "fix this first"
exit

# Define the source directory where the script will search for video files
source_dir="/hoard/incoming"

destination_dir="/media/sacha/moshpit"
general_destination_dir="$destination_dir/movies"
tv_shows_destination_dir="$destination_dir/tv"
music_destination_dir="$destination_dir/Music/incoming"

# Create the destination directories if they don't exist
mkdir -p "$general_destination_dir"
mkdir -p "$tv_shows_destination_dir"
mkdir -p "$music_destination_dir"

# Use find to locate files
find "$source_dir" -type f | while read -r file; do

    # Get the file extension in lowercase
    ext="${file##*.}"
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    # Check for specific file types and act accordingly
    case "$ext_lower" in
        mp4|mkv|avi|mpeg|mpg)
            # Check if the filename contains a TV show pattern like S01E01, s02e03, etc.
            if [[ "$(basename "$file")" =~ [Ss][0-9]{2}[Ee][0-9]{2} ]]; then
                # Move the file to the TV shows directory
                mv "$file" "$tv_shows_destination_dir"
            else
                # Move the file to the general videos directory
                mv "$file" "$general_destination_dir"
            fi
            ;;
        mp3)
            # Move mp3 files to the music directory
            mv "$file" "$music_destination_dir"
            ;;
        nfo|jpg|txt)
            # Delete files with .nfo, .jpg, or .txt extensions
            rm "$file"
            ;;
    esac

done

# Remove empty directories
find "$source_dir" -mindepth 1 -type d -empty -delete

echo "Files have been processed, moved, and empty directories have been removed."

