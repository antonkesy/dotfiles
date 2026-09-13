#!/usr/bin/env bash

if ! pgrep -x missioncenter >/dev/null; then
	missioncenter &
	sleep 2.5
fi

hyprctl dispatch 'hl.dsp.workspace.toggle_special("missioncenter")'
