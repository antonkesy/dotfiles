#!/bin/bash
# Pull the SSH and GPG keys off the NAS onto a fresh machine: `make import-keys`.
# The staging copy at /mnt/nas/ak/setup mirrors ~/.ssh and ~/.gnupg; refresh it by
# hand whenever a key changes, this only ever reads it.
#
# Deliberately not a `cp -a` of that tree:
#   - gpg.conf / gpg-agent.conf are symlinks into /nix/store that home-manager owns
#   - public-keys.d carries keyboxd lock files belonging to whichever machine made
#     the copy, and a stale lock keeps gpg from opening the keyring at all
#   - modes on the share are whatever file_mode=0600 / dir_mode=0700 painted on, not
#     the modes ssh and gpg insist on
# The .gnupg half therefore names what it wants instead of filtering what it does
# not: an allowlist cannot be widened by a stray file landing in the copy, and over
# cifs the file type is not even reliable -- `find -type f` matched that gpg.conf
# symlink, `find -type l` did not.
set -euo pipefail

src="${NAS_SETUP:-/mnt/nas/ak/setup}"
share="/mnt/nas/ak"
stamp="$(date +%Y%m%d-%H%M%S)"

# Everything under ~/.gnupg that is key material or says how to read it. Anything
# else there -- the home-manager configs, sshcontrol, random_seed, crls.d, the
# keyboxd locks -- belongs to the machine, not to the keys.
gnupg_wanted=(
	common.conf
	trustdb.gpg
	pubring.kbx
	"private-keys-v1.d/*.key"
	"public-keys.d/pubring.db"
	"openpgp-revocs.d/*.rev"
)

die() {
	echo "import-keys: $*" >&2
	exit 1
}

[ "$(id -u)" -ne 0 ] || die "run this as yourself, not root -- the keys go into your home"

# The share is noauto,user and only mounted while you are logged in, so a missing
# one is normal rather than an error; try to bring it up before giving up.
if [ ! -d "$src" ]; then
	mountpoint -q "$share" || mount "$share" || true
	[ -d "$src" ] || die "$src is not there. Is the NAS mounted? See 'systemctl --user status nas-mount.service'"
fi

# `install` opens the target O_TRUNC, which fails on the 0400 private keys, so the
# replacement goes through rm + cp instead.
install_file() {
	local from="$1" to="$2" mode="$3"

	if [ -e "$to" ] && cmp -s "$from" "$to"; then
		echo "  = $to"
		return
	fi
	if [ -e "$to" ]; then
		mv "$to" "$to.bak.$stamp"
		echo "  ~ $to -> $to.bak.$stamp"
	fi
	cp "$from" "$to"
	chmod "$mode" "$to"
	echo "  + $to ($mode)"
}

if [ -d "$src/.ssh" ]; then
	echo "ssh keys from $src/.ssh"
	mkdir -p "$HOME/.ssh"
	chmod 700 "$HOME/.ssh"
	for from in "$src"/.ssh/*; do
		[ -f "$from" ] && [ ! -L "$from" ] || continue
		name="$(basename "$from")"
		case "$name" in
		*.pub | config | known_hosts* | authorized_keys) mode=644 ;;
		*) mode=600 ;;
		esac
		install_file "$from" "$HOME/.ssh/$name" "$mode"
	done
fi

if [ -d "$src/.gnupg" ]; then
	echo "gpg keys from $src/.gnupg"
	mkdir -p "$HOME/.gnupg"
	chmod 700 "$HOME/.gnupg"
	shopt -s nullglob
	for pattern in "${gnupg_wanted[@]}"; do
		# unquoted on purpose: these are globs, not paths
		for from in "$src"/.gnupg/$pattern; do
			# nullglob only swallows patterns; the plain names survive unmatched
			[ -e "$from" ] || continue
			to="$HOME/.gnupg/${from#"$src"/.gnupg/}"
			mkdir -p "$(dirname "$to")"
			install_file "$from" "$to" 600
		done
	done
	shopt -u nullglob
	find "$HOME/.gnupg" -type d -exec chmod 700 {} +

	# Without common.conf gpg does not talk to keyboxd, ignores public-keys.d and
	# finds no public keys at all -- so the secret keys it did import look unusable.
	if [ -f "$HOME/.gnupg/public-keys.d/pubring.db" ] && [ ! -e "$HOME/.gnupg/common.conf" ]; then
		echo "use-keyboxd" >"$HOME/.gnupg/common.conf"
		chmod 600 "$HOME/.gnupg/common.conf"
		echo "  + $HOME/.gnupg/common.conf (use-keyboxd, missing from the copy)"
	fi

	# Pick up the new keyring instead of serving the one cached before the import.
	gpgconf --kill all >/dev/null 2>&1 || true
fi

echo
gpg --list-secret-keys --keyid-format=long || true

# commit.gpgsign is on, so a missing signing key only shows up at the first commit.
signingkey="$(git config --get user.signingkey 2>/dev/null || true)"
if [ -n "$signingkey" ] && ! gpg --list-secret-keys "$signingkey" >/dev/null 2>&1; then
	echo "import-keys: warning: git signs with $signingkey, which is not among the imported secret keys" >&2
fi
