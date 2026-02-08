#!/usr/bin/env bash

if ! pgrep -x gnome-calendar >/dev/null; then
	gnome-calendar &
	sleep 0.5
else
	# Move existing Gnome-Calendar window to special workspace
	hyprctl dispatch movetoworkspacesilent special:calendar,class:org.gnome.Calendar
fi

hyprctl dispatch togglespecialworkspace calendar
