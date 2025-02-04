#!/usr/bin/bash

rsync -rav \
        --exclude .git/ \
        --exclude .cache/ \
        --exclude .config/ \
        --exclude .local/ \
        --exclude .ssh/ \
        --exclude .var/ \
        --exclude __pycache__/ \
        /backup/hoard \
        /work \
        /moshpit \
        /home \
        happy@happy.local:/Volumes/storage/ --delete
