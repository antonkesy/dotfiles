#!/usr/bin/env bash

if ! pgrep -x Discord >/dev/null; then
	discord &
	sleep 0.1
else
	# Move existing discord window to special workspace
	hyprctl dispatch movetoworkspacesilent special:discord,class:^discord$
fi

hyprctl dispatch togglespecialworkspace discord
