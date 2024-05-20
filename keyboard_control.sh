#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <string>"
    exit 1
fi

# Store the argument
command="$1"
year=$(date +%Y)
app="Music"
voice="Fiona"
max_vol=80
min_vol=20
vol_inc=10
default_playlist="_New Music" # "${year} top plays"
notification_title="Music command"
music_dir="/Volumes/moshpit/Music/Music"
local_music_dir="/home/sacha/happy_share/"

# display notification \"liked\" with title \"${notification_title}\"
if [ "$command" == "like" ]; then
         instruction="
           tell application \"Last.fm\" to love
           if player state is playing then -- like if a song is playing
             if loved of current track is false then
               set loved of current track to true
               say \"liked\" using \"${voice}\"
             else
               say \"already liked\" using \"${voice}\"
             end if

             try -- determine if the track is local
               set thePath to POSIX path of (get location of current track)
             on error
               set thePath to null
               set trackProperties to (properties of current track)
               set trackName to name of trackProperties
               set artistName to artist of trackProperties
               set albumName to album of trackProperties

               set musicPath to POSIX path of \"${music_dir}/\"
               set albumPath to quoted form of (musicPath & artistName & \"/\" & albumName & \"/\")
               -- display dialog albumPath
             end try

           else -- otherwise start a playlist
             play playlist named \"${default_playlist}\"
           end if "

elif [ "$command" == "mute" ]; then
        instruction="
          set mute to not (get mute)"

elif [ "$command" == "vol_up" ]; then
        instruction="
          if the sound volume is less than ${max_vol} then
            set sound volume to (sound volume + ${vol_inc})
          end if"

elif [ "$command" == "vol_down" ]; then
        instruction="
          if the sound volume is greater than ${min_vol} then
            set sound volume to (sound volume - ${vol_inc})
          end if"

elif [ "$command" == "replay" ]; then
        instruction="
          if player position > 10 then
            set player position to 0
          else
            previous track
          end if"

else
        instruction="${command}"

fi

# send the message
dialog_text=$(ssh happy@happy.local "osascript -e '
    tell application \"${app}\"
      ${instruction}
    end tell '")

# echo $dialog_text
# if there's a return value, check if the file/dir exists
if [ -n "$dialog_text" ]; then
  file_exists=true

  # echo "Server location:"
  # echo $dialog_text

  short_dir=${dialog_text:24}
  if [[ $short_dir != M* ]]; then
    short_dir="M${short_dir}"
  fi
  # (/Jane'\''s Addiction/Nothing'\''s Shocking/)
  if [[ $short_dir == *\'* ]]; then
    # replace escaped single quotes
    short_dir="${short_dir//\'\\\'\'/_}"
  fi

  if [[ $short_dir =~ \'$ ]]; then
    localised_file="${local_music_dir}${short_dir::-1}"
  else
    localised_file="${local_music_dir}${short_dir}"
  fi
  # echo "local location:"
  # echo "$localised_file"

  # sometimes a dir (Pink Floyd/The Wall/),
  # or file (The Be Good Tanyas/Blue Horse/03 Rain and Snow.mp3)
  if [ ! -d "$localised_file" ] && [ ! -f "$localised_file" ] ; then
    echo "$localised_file file/dir does not exist"
    #
    # 'Beastie Boys/Ill Communication (Deluxe Edition)/'?
    #
    if [[ $localised_file == *" ("* ]]; then
      echo "has a bracket"
      truncated_dir="${localised_file% (*}/"
      echo "$truncated_dir"
      if [ ! -d "$truncated_dir" ]; then
        echo "$truncated_dir file/dir does not exist"
        # file doesn't exist
        file_exists=false
      fi
    else
      # file doesn't exist
      file_exists=false
    fi
  fi

  # echo $file_exists
  if [ "$file_exists" = false ]; then
        echo "$truncated_dir file/dir does not exist"

        artist_album=${short_dir:6:-1}
        zenity --question --text="${artist_album}?" --title="Fetch?" --timeout=8

        # handle the dialog response and do something with it
        # echo $?
        # Yes:       0
        # No/Cancel: 1
        # Timeout:   5
        if [[ $? == 0 ]]; then
          encoded_url="${artist_album// /+}"
          # encoded_url="${encoded_url//\// }"
          # xdg-open https://www.last.fm/search?q=${encoded_url:6}
          # https://www.last.fm/music/Greenleaf/Hear+The+Rivers
          xdg-open https://www.last.fm/music/${encoded_url}  2>/dev/null
        fi
  fi
fi
