#!/usr/bin/bash

REMOTE_HOST="monster.local"
REMOTE_PATH="/storage"
if ssh "${REMOTE_HOST}" "mountpoint -q '$REMOTE_PATH'"; then
        rsync -rav \
                --exclude .git/ \
                --exclude .cache/ \
                --exclude .config/ \
                --exclude .local/ \
                --exclude .ssh/ \
                --exclude .var/ \
                --exclude __pycache__/ \
                --exclude .ollama/id_ed25519 \
                /home \
                /usr/share/ollama \
                /work \
                sacha@monster.local:/storage/venus --delete

        ssh "${REMOTE_HOST}" "touch /storage/venus-timestamp.txt"
fi
