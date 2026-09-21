#!/bin/bash
state="$HOME/.cache/i3-mirror-state"
[ -f "$state" ] || exit 0

# a transform survives --off, so clear it before any other script repositions outputs
for o in $(xrandr --query | grep " connected" | cut -d' ' -f1); do
  xrandr --output "$o" --scale 1x1
done

[ -s "$state" ] && brightnessctl -q set "$(cat "$state")"
rm -f "$state"
