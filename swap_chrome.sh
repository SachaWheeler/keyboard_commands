#!/bin/bash

# Path to the temporary file
temp_file="/tmp/chrome_window_id.txt"

# Get the window ID of the frontmost Chrome window and save it to the temporary file
get_frontmost_window_id() {
    wmctrl -l | grep "Google Chrome" | head -n 1 | awk '{print $1}' > "$temp_file"
}

# Swap the frontmost Chrome window with the other Chrome window
swap_chrome_windows() {
    # Read the frontmost window ID from the temporary file
    frontmost_window_id=$(cat "$temp_file")

    # Get all Chrome window IDs except the frontmost one
    chrome_window_ids=$(wmctrl -l | grep "Google Chrome" | awk '{print $1}' | grep -v "$frontmost_window_id")

    # If there's another Chrome window, swap the frontmost window with it
    if [ -n "$chrome_window_ids" ]; then
        # Get the first Chrome window ID (excluding the frontmost one)
        other_window_id=$(echo "$chrome_window_ids" | head -n 1)

        # Swap the frontmost window with the other window
        wmctrl -i -a "$other_window_id"

        # Save the new frontmost window ID to the temporary file
        echo "$other_window_id" > "$temp_file"
    else
        echo "No other Chrome windows found."
    fi
}

# Check if the temporary file exists
# if [ ! -f "$temp_file" ]; then
if [ ! -e "$temp_file" ] || [ "$temp_file" -ot "$(date -d '1 day ago' '+%s')" ]; then
    get_frontmost_window_id
else
    swap_chrome_windows
fi

