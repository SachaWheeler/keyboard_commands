#!/usr/bin/bash

rsync -rav \
        --exclude .git/ \
        --exclude .cache/ \
        --exclude .config/ \
        --exclude .local/ \
        --exclude .ssh/ \
        --exclude .var/ \
        --exclude __pycache__/ \
        /home \
        /usr/share/ollama \
        /work \
        sacha@monster.local:/storage/venus --delete

touch /storage/venus-timestamp.txt
