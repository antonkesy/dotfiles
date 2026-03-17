#!/usr/bin/env bash

if ! pgrep -x amberol >/dev/null; then
	amberol &
	sleep 0.5
else
	# Move existing Gnome-Calendar window to special workspace
	hyprctl dispatch movetoworkspacesilent special:calendar,class:io.bassi.Amberol
fi

hyprctl dispatch togglespecialworkspace amberol
