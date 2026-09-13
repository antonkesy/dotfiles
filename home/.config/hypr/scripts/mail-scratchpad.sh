#!/usr/bin/env bash

if ! pgrep -x thunderbird >/dev/null; then
	thunderbird &
	sleep 0.5
fi

hyprctl dispatch 'hl.dsp.workspace.toggle_special("mail")'
