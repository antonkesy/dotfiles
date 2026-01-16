#!/usr/bin/env bash

if ! pgrep -x missioncenter >/dev/null; then
	missioncenter &
	sleep 2.5
else
	# Move existing Mission-Center window to special workspace
	hyprctl dispatch movetoworkspacesilent special:missioncenter,class:io.missioncenter.MissionCenter
fi

hyprctl dispatch togglespecialworkspace missioncenter
