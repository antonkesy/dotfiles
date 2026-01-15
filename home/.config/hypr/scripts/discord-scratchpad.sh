#!/usr/bin/env bash

if ! pgrep -x discord >/dev/null; then
	discord &
	sleep 0.5
fi

hyprctl dispatch togglespecialworkspace discord
