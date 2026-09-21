#!/bin/bash
bash "$HOME/.config/i3/xrandr-unmirror.sh"
main="eDP"

for o in $(xrandr --query | grep " connected" | cut -d' ' -f1 | grep -v "^$main$"); do
  xrandr --output "$o" --off
done

xrandr --output "$main" --auto --primary
