#!/usr/bin/env bash

if ! pgrep -x amberol >/dev/null; then
	amberol &
	sleep 0.5
fi

hyprctl dispatch 'hl.dsp.workspace.toggle_special("music")'
