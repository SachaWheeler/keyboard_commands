#!/bin/bash

# Define CPU threshold and process name
CPU_THRESHOLD=60
PROCESS_NAME="Plex Music Analyzer"
LOG_FILE="$HOME/.plex_analyzer_last_run.log"

# Get the current CPU load percentage
cpu_load=$(awk '{print $1 * 100}' < /proc/loadavg)

# Check if the CPU load exceeds the threshold
if (( ${cpu_load%.*} > CPU_THRESHOLD )); then
    # Check if the process is running
    if pgrep -f "$PROCESS_NAME" > /dev/null; then
        # Get the last run time
        last_run=$(cat "$LOG_FILE" 2>/dev/null || echo 0)
        current_time=$(date +%s)

        # Check if it's been over an hour since the last alert
        if (( current_time - last_run >= 3600 )); then
            # Update the log file with the current time
            echo "$current_time" > "$LOG_FILE"

            # Send an alert (you can customize this with notify-send or other notification tools)
            notify-send "Alert: $PROCESS_NAME running with high CPU load" \
                "CPU Load: $cpu_load%"
            /new-home/sacha/bin/mac_say.sh "Plex Music Analyzer is running"
        fi
    fi
fi
#/home/sacha/bin/mac_say.sh "Plex Music Analyzer is running"
