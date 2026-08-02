#!/usr/bin/env bash

if ! pgrep -x gnome-calendar >/dev/null; then
	gnome-calendar &
	sleep 0.5
fi

hyprctl dispatch 'hl.dsp.workspace.toggle_special("calendar")'
