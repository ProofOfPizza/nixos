#!/usr/bin/env bash

OUTPUT=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .output')

echo "Detected output: $OUTPUT" >&2

if [ "$OUTPUT" = "HDMI-A-0" ]; then
    FONT_SIZE=18
else
    FONT_SIZE=15
fi

exec alacritty --option font.size="$FONT_SIZE"