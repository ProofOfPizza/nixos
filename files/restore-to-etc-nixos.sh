
#!/usr/bin/env bash

# Define the source and destination directories
SRC_DIR="$HOME/nixos-config/files"
DEST_DIR="/etc/nixos"

# Use sudo to copy the contents of the source directory to the destination directory and preserve permissions
sudo rsync -av --delete $SRC_DIR/ $DEST_DIR/