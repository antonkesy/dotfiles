#!/usr/bin/env bash
set -euo pipefail

choice=$(
	ps -eo pid,comm,%cpu,%mem --sort=-%cpu |
		sed 1d |
		rofi -dmenu -i -p "Kill process" \
			-location 0 -width 40 -lines 20
)

pid=$(awk '{print $1}' <<<"$choice")
[ -n "${pid:-}" ] && kill -9 "$pid"
