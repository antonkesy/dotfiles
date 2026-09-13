#!/usr/bin/env bash
# Phase 1 of a fresh Arch install, on the live ISO: archinstall with
# archinstall.json pre-seeded (GRUB, locale, NetworkManager, the packages
# phase 2 needs, profile Minimal -- no desktop, no greeter, no gfx driver).
# Partitioning and the root/user passwords are set in archinstall's menu.
#
#   iwctl station wlan0 connect <SSID>                  # wifi, if needed
#   curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/install.sh | bash
#
# Phase 2, after the reboot, as the created user (nmcli device wifi connect <SSID> --ask):
#   curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
# which installs ansible, clones dotfiles into ~/Projects and runs
# `make arch` -- the system half via ansible, then home-manager takes over.
set -euo pipefail

RAW=https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch
CONF=/tmp/archinstall.json

# From a checkout use the local file, from `curl | bash` fetch it.
LOCAL="$(dirname "${BASH_SOURCE[0]:-.}")/archinstall.json"
if [ -f "$LOCAL" ]; then
	cp "$LOCAL" "$CONF"
else
	curl -fsSL "$RAW/archinstall.json" -o "$CONF"
fi

echo "archinstall (host ak): set 'Disk configuration' and 'Authentication' in the menu, then Install."
archinstall --config "$CONF"
