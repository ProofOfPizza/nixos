#!/bin/bash

# Detect the number of monitors
MONITORS=$(xrandr --listmonitors | grep Monitors | awk '{print $2}')

if [[ "$MONITORS" -gt 1 ]]; then
    FONT_SIZE=15  # Larger font for multiple monitors
else
    FONT_SIZE=11  # Default font size
fi

# Start Alacritty with the adjusted font size
env ALACRITTY_FONT_SIZE=$FONT_SIZE alacritty --option font.size=$FONT_SIZE