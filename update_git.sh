#!/bin/bash

cd /work/github-mirror
for dir in *.git; do
  echo "Fetching updates for $dir..."
  (cd "$dir" && git remote update --prune)
done

rsync -a --delete /work/github-mirror sacha@monster.local:/backup/github/
ssh monster "touch /backup/github/timestamp.txt"
