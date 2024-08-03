#!/bin/bash
connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
cute="xrandr "
xrandr --auto
main="eDP-1"
if echo $connectedOutputs | grep "HDMI-1";
  then
    cute_too=$cute"--output HDMI-1 --off";
    echo $cute_too; `$cute_too`;
    cute_three=$cute"--auto";
    echo $cute_three; `$cute_three`;
elif echo $connectedOutputs | grep "HDMI-2";
  then
    cute_too=$cute"--output HDMI-2 --off";
    echo $cute_too; `$cute_too`;
    cute_three=$cute"--auto";
    echo $cute_three; `$cute_three`;
fi;
