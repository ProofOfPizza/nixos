#!/bin/bash
connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
cute="xrandr "
xrandr --auto
main="eDP-1"
if echo $connectedOutputs | grep "HDMI-1";
  then
    cute_too=$cute"--output HDMI-1 --mode 1920x1080 --above $main";
    echo $cute; `$cute`;
    cute=$cute"--output $main --mode 1920x1080 --below HDMI-1";
    echo $cute_too; `$cute_too`;
elif echo $connectedOutputs | grep "HDMI-2";
  then
    cute_too=$cute"--output HDMI-2 --mode 1920x1080 --rate 119.98 --above $main";
    echo $cute; `$cute`;
    cute=$cute"--output $main --mode 1920x1080 --rate 119.98 --below HDMI-2";
    echo $cute_too; `$cute_too`;
fi;
