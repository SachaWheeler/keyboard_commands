#!/bin/bash

# Ensure the script receives two arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <destination> <source>"
    exit 1
fi

# Assign arguments to variables
dir1="$1"
dir2="$2"

# Check if both directories exist
if [[ ! -d "$dir1" || ! -d "$dir2" ]]; then
    echo "Both arguments must be valid directories."
    exit 1
fi

# List contents of the directories
echo "Contents of $dir1:"
ls "$dir1"
echo
echo "Contents of $dir2:"
ls "$dir2"

# Prompt the user for confirmation
read -p "Would you like to continue and replace files in $dir1 with matching files from $dir2? (yes/no): " response

# Check user response
if [[ "$response" != "yes" ]]; then
    echo "Operation canceled."
    exit 0
fi

# Proceed with the replacement
echo "Starting the replacement process..."
find "$dir1" -type f | while read -r file1; do
    # Extract the number prefix from the file1
    number=$(basename "$file1" | cut -d' ' -f1)

    # Check if a file with the same number exists in dir2
    replacement=$(find "$dir2" -type f -name "${number}*")
    if [[ -n $replacement ]]; then
        # Replace file1 with the replacement, keeping the original filename
        mv "$replacement" "$file1"
        echo "Replaced: $file1 with $replacement"
    fi
done
# remove empty dirs
# find "$dir2" -mindepth 1 -type d -empty -print -delete
find /moshpit/Music/upgrades -mindepth 1 -type d -empty -delete


echo "File replacement process completed."

