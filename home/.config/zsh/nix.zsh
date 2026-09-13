#!/bin/zsh

# Wire nix (multi-user daemon install on Arch, single-user on WSL) and the
# home-manager session variables into every shell.

if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
	source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
	source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
	source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
