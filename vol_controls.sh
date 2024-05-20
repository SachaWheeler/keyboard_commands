#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <string>"
    exit 1
fi

# Store the argument
command="$1"
max_vol=50
min_vol=20
vol_inc=5

# display notification \"liked\" with title \"${notification_title}\"
if [ "$command" == "mute" ]; then
        instruction="
    set currentVolume to output volume of (get volume settings)
    if currentVolume > 0 then
        set volume output volume 0
    else
        set volume output volume ${max_vol}
    end if
"

elif [ "$command" == "vol_up" ]; then
        instruction="
    set currentVolume to output volume of (get volume settings)
    if currentVolume < ${max_vol} then
        set newVolume to currentVolume + ${vol_inc}
        set volume output volume newVolume
    end if
        "
elif [ "$command" == "vol_down" ]; then
        instruction="
    set currentVolume to output volume of (get volume settings)
    if currentVolume > ${min_vol} then
        set newVolume to currentVolume - ${vol_inc}
        set volume output volume newVolume
    end if
        "
fi

# send the message
dialog_text=$(ssh happy@happy.local "osascript -e '
    tell application \"Finder\"
      ${instruction}
    end tell '")

