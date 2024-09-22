#!/usr/bin/env python

import os
import shutil
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, TIT2, TPE1, TALB, TRCK
from pydub import AudioSegment

def convert_to_mp3(file_path, output_path):
    """Convert an audio file to MP3 format."""
    audio = AudioSegment.from_file(file_path)
    audio.export(output_path, format="mp3")

def get_mp3_metadata(file_path):
    """Retrieve metadata from an MP3 file."""
    audio = MP3(file_path, ID3=ID3)
    tags = audio.tags
    title = tags.get('TIT2', 'Unknown Title').text[0]
    artist = tags.get('TPE1', 'Unknown Artist').text[0]
    album = tags.get('TALB', 'Unknown Album').text[0]
    track_number = tags.get('TRCK', '0').text[0].split('/')[0].zfill(2)
    return title, artist, album, track_number

def process_audio_files(directory, music_directory):
    """Scan the directory for audio files, convert and organize them."""
    if not os.path.exists(music_directory):
        os.makedirs(music_directory)

    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if not file.lower().endswith('.mp3'):
                continue
                # Convert non-MP3 files to MP3
                mp3_path = os.path.splitext(file_path)[0] + '.mp3'
                try:
                    convert_to_mp3(file_path, mp3_path)  # skip jpgs, etc.
                except Exception as e:
                    print(e, file_path)
                    continue
                file_path = mp3_path

            # Retrieve and use MP3 metadata for renaming and organizing
            try:
                title, artist, album, track_number = get_mp3_metadata(file_path)
            except Exception as e:
                print(f"Error reading metadata from {file_path}: {e}")
                continue

            # Create artist and album directories
            artist_dir = os.path.join(music_directory, artist)
            album_dir = os.path.join(artist_dir, album)
            os.makedirs(album_dir, exist_ok=True)

            # Define new file name and path
            new_file_name = f"{track_number} {title}.mp3"
            new_file_path = os.path.join(album_dir, new_file_name)

            # Move and rename the file
            shutil.move(file_path, new_file_path)
            print(f"Moved {file_path} to {new_file_path}")

            # Check if the original directory is empty and remove it if it is
            original_dir = os.path.dirname(file_path)
            if not os.listdir(original_dir) and not original_dir.endswith("/incoming"):
                os.rmdir(original_dir)
                print(f"Removed empty directory: {original_dir}")

# Define the directory to scan and the music directory
root = '/media/sacha/moshpit/Music'
directory_to_scan = f'{root}/incoming'
music_directory = f'{root}/Music'

# Process the audio files
process_audio_files(directory_to_scan, music_directory)

