#!/bin/bash
# Hyprland plugins, run as the user at the end of `make arch`.
# hyprpm update/enable write root-owned state under /var/cache/hyprpm and ask
# for sudo even when nothing changed, so compare first and only call them when
# needed. Hyprland does not need to be running except for the final reload,
# which hyprland.lua also does on start.
set -euo pipefail

# build with the system toolchain and pkgconf, not the nix ones on PATH
export PATH="/usr/bin:$PATH"

state=/var/cache/hyprpm/$USER
url=https://github.com/virtcode/hypr-dynamic-cursors

abi=$(Hyprland --version | sed -n 's/^Version ABI string: //p')
headers=$(sed -n "s/^hash = '\(.*\)'/\1/p" "$state/state.toml" 2>/dev/null || true)
have=$(sed -n "s/^hash = '\(.*\)'/\1/p" "$state/dynamic-cursors/state.toml" 2>/dev/null || true)
want=$(git ls-remote "$url" HEAD | cut -f1)

if [ "$abi" != "$headers" ] || [ "$want" != "$have" ]; then
	hyprpm update
fi
hyprpm list | grep -q dynamic-cursors || yes | hyprpm add "$url"
grep -q '^enabled = true' "$state/dynamic-cursors/state.toml" 2>/dev/null || hyprpm enable dynamic-cursors
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
	hyprpm reload
fi
