#!/bin/bash
main="eDP"
dim=1%
mode="$1"
state="$HOME/.cache/i3-mirror-state"

ext=$(xrandr --query | grep " connected" | cut -d' ' -f1 | grep -v "^$main$" | head -1)
if [ -z "$ext" ]; then
  echo "no external output connected"
  exit 1
fi

# the projector is the screen being watched, so it drives the framebuffer at its
# native mode and the aspect mismatch is absorbed by the dimmed laptop panel
if [ -n "$mode" ]; then
  xrandr --output "$ext" --mode "$mode" ${2:+--rate "$2"} --primary --scale 1x1
else
  xrandr --output "$ext" --auto --primary --scale 1x1
fi
fb=$(xrandr --query | awk -v o="$ext" '$1==o{f=1;next} /^[^ \t]/{f=0} f && /\*/{print $1; exit}')
if [ -z "$fb" ]; then
  echo "could not determine mode of $ext"
  exit 1
fi

xrandr --output "$main" --auto --same-as "$ext" --scale-from "$fb"

mkdir -p "$(dirname "$state")"
[ -f "$state" ] || brightnessctl get > "$state"
brightnessctl -q set "$dim"
