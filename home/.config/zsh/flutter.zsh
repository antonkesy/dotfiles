#!/bin/zsh

if [ -z "$CHROME_EXECUTABLE" ] && command -v google-chrome-stable >/dev/null 2>&1; then
	export CHROME_EXECUTABLE="$(command -v google-chrome-stable)"
fi
