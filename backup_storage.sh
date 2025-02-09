#!/usr/bin/bash

rsync -ra \
        --exclude .git/ \
        --exclude .cache/ \
        --exclude .config/ \
        --exclude .local/ \
        --exclude .ssh/ \
        --exclude .var/ \
        --exclude __pycache__/ \
        /moshpit \
        /work \
        /home \
        /backup/hoard \
        pi@pihole.local:/media/pi/storage/ --delete
