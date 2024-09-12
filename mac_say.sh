#!/bin/bash

# Check if a string argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <text-to-speak>"
  exit 1
fi

# Variables
REMOTE_USER="happy"  # Replace with your username on the Mac
REMOTE_HOST="happy.local"  # Replace with the IP address or hostname of the Mac
TEXT_TO_SAY="$1"

# Connect to the remote Mac and execute the say command
ssh "$REMOTE_USER@$REMOTE_HOST" "say -v Fiona '$TEXT_TO_SAY'"

