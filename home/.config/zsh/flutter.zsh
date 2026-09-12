#!/bin/zsh

# flutter itself comes from home-manager; only tell it which browser to use
# unless the environment (hm-session-vars) already did.
if [ -z "$CHROME_EXECUTABLE" ] && command -v google-chrome-stable >/dev/null 2>&1; then
	export CHROME_EXECUTABLE="$(command -v google-chrome-stable)"
fi
