#!/usr/bin/env bash

# Define the source and destination directories
SRC_DIR="/etc/nixos"
DEST_DIR="$HOME/nixos-config/files"

# Use sudo to copy the contents of /etc/nixos to the destination directory and preserve permissions
sudo rsync -av --delete $SRC_DIR/ $DEST_DIR/

# Change ownership of the copied files to the current user
sudo chown -R $(whoami):$(whoami) $DEST_DIR

# Change to the root of the git repository
cd $HOME/nixos-config

# Add changes to git
git add files/

# Prompt for a commit message
echo "Enter commit message:"
read COMMIT_MSG

# Commit the changes with the provided message
git commit -m "$COMMIT_MSG"

# Push the changes to the remote repository
git push origin main