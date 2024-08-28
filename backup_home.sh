#!/bin/bash

# Directory to backup
source_directory="/home/sacha"

# Directory to store backups
# backup_directory="/Volumes/Seagate"
backup_directory="/media/sacha/cormac/home"

# Maximum number of backups to keep
max_backups=4

# Date format for backup folder
date_format="%Y-%m-%d"

# Create a new dated backup folder
backup_folder="$backup_directory/$(date +$date_format)"
mkdir -p "$backup_folder"

# Run rsync to perform the backup
rsync -av --exclude=".*" "$source_directory/" "$backup_folder"

# Remove older backups
cd "$backup_directory" || exit
ls -1d */ | sort -r | tail -n +$((max_backups+1)) | xargs rm -rf

