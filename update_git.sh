#!/bin/bash

USERNAME="SachaWheeler"
BACKUP_DIR="/backup/github/$USERNAME"
mkdir -p "$BACKUP_DIR"

# Fetch all repo names (you can add --private if you have private repos)
repos=$(gh repo list "$USERNAME" --json name -q '.[].name')

# Loop through each repo
for repo in $repos; do
    REPO_DIR="$BACKUP_DIR/$repo"
    REPO_URL="https://github.com/$USERNAME/$repo.git"

    if [ -d "$REPO_DIR/.git" ]; then
        echo "Updating $repo..."
         git -C "$REPO_DIR" pull
        # gh repo sync "$REPO_DIR"
    else
        echo "Cloning $repo..."
        # git clone "$REPO_URL" "$REPO_DIR"
        gh repo clone "$REPO_URL" "$REPO_DIR"
    fi
done


# cd /work/github-mirror
# for dir in *.git; do
  # echo "Fetching updates for $dir..."
  # (cd "$dir" && git remote update --prune)
# done

# rsync -a --delete /work/github-mirror sacha@monster.local:/backup/github/
# ssh monster "touch /backup/github/timestamp.txt"
#

# mkdir -p /work/github-mirror
# cd /work/github-mirror

# List all your GitHub repos
# gh repo list SachaWheeler --limit 1000 --json nameWithOwner,sshUrl -q '.[] | .sshUrl' |
# while read repo; do
  # name=$(basename "$repo" .git)
  # echo "Cloning $name..."
  # git clone --mirror "$repo" "$name.git"
# done

