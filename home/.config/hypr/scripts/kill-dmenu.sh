#!/usr/bin/env bash

set -euo pipefail

choice=$(
	ps -eo pid,comm,%cpu,%mem --sort=-%cpu |
		sed 1d |
		dmenu -i -l 20 -p "Kill process:"
)

pid=$(awk '{print $1}' <<<"$choice")

[ -n "${pid:-}" ] && kill -9 "$pid"
