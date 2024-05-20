#!/bin/bash

# Define the application name
process_name="nicotine"
app_name="Nicotine+"

# Check if the application is running
if pgrep -x "$process_name" > /dev/null; then
    # If running, get the window ID
    window_id=$(wmctrl -l | grep "$app_name" | awk '{print $1}')
    echo "id: ${window_id}"

    # Toggle window stacking order (above or below)
    current_state=$(xprop -id "$window_id" _NET_WM_STATE | grep "_NET_WM_STATE_ABOVE")
    echo "state: ${current_state}"

    if [ -z "$current_state" ]; then
        wmctrl -i -r "$window_id" -b remove,below,shaded
        wmctrl -i -r "$window_id" -b add,above
        echo "Toggled $app_name window above all others."
    else
        wmctrl -i -r "$window_id" -b remove,above
        wmctrl -i -r "$window_id" -b add,below,shaded
        echo "Toggled $app_name window below all others."
    fi

else
    # If not running, start the application
    echo "$app_name is not running. Starting it now."
    # Example: /path/to/whatsdesk &
    flatpak run org.nicotine_plus.Nicotine &
fi

