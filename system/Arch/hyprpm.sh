#!/bin/bash
# Hyprland plugins, run as the user at the end of `make arch`.
# The first `hyprpm update` builds the Hyprland headers into /var/cache/hyprpm
# (asks for sudo); Hyprland does not need to be running except for the final
# reload, which hyprland.lua also does on start.
set -euo pipefail

# build with the system toolchain and pkgconf, not the nix ones on PATH
export PATH="/usr/bin:$PATH"

hyprpm update
hyprpm list | grep -q dynamic-cursors || yes | hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
	hyprpm reload
fi
