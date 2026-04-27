#!/usr/bin/env bash

if ! pgrep -x amberol >/dev/null; then
	amberol &
	sleep 0.5
else
	# Move existing Amberol window to special workspace
	hyprctl dispatch movetoworkspacesilent special:music,class:io.bassi.Amberol
fi

hyprctl dispatch togglespecialworkspace music
