#!/bin/zsh

# NixOS wires nix and the home-manager session variables into every login
# shell itself; on any other distro do it here.
[ -e /etc/NIXOS ] && return 0

if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
	source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
	source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
