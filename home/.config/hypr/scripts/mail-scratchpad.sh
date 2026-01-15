#!/usr/bin/env bash

if ! pgrep -x thunderbird >/dev/null; then
	thunderbird &
	sleep 0.5
else
	# Move existing Thunderbird window to special workspace
	hyprctl dispatch movetoworkspacesilent special:mail,class:org.mozilla.Thunderbird
fi

hyprctl dispatch togglespecialworkspace mail
