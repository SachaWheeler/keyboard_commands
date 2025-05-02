#!/bin/bash
#

# PROCESS=$(ps -eo comm,%cpu --sort=-%cpu | awk 'NR==2 {print $1, $2}')
# mac_say.sh "top process is $PROCESS percent"

LOCKFILE="/tmp/top_cpu_process.lock"

# Check if lock file exists and if the process in it is still running
if [ -e "$LOCKFILE" ] && kill -0 "$(cat "$LOCKFILE")" 2>/dev/null; then
    echo "Script is already running (PID $(cat "$LOCKFILE")). Exiting."
    exit 1
fi

# Write current PID to lock file
echo $$ > "$LOCKFILE"

# Trap cleanup on exit
trap 'rm -f "$LOCKFILE"' EXIT

# --- Your actual script logic ---
read pname pcpu <<< $(ps -eo comm,%cpu --sort=-%cpu | awk 'NR==2 {print $1, $2}')
# echo "Top CPU-consuming process: $pname using $pcpu% CPU"

pcpu_rounded=$(printf "%.0f" "$pcpu")

mac_say.sh "top process is $pname with $pcpu_rounded percent"

