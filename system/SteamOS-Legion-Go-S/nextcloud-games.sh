#!/bin/bash
# copies Nextcloud's Emulation/{roms,bios} into EmuDeck's folders; copy only, never deletes
set -euo pipefail

RCLONE="$HOME/.local/bin/rclone"
SECRET="${XDG_CONFIG_HOME:-$HOME/.config}/rclone/nextcloud-app-password"
SETTINGS="$HOME/.config/EmuDeck/settings.sh"
# same layout as ~/Emulation: roms/<system>, bios
REMOTE="nextcloud:${NEXTCLOUD_GAMES:-Emulation}"
RCLONE_FLAGS=(--contimeout 10s --low-level-retries 3)

# konsole closes with the script, keep the result readable
trap 'read -rt 30 -p "closing in 30s, enter closes now" _ || true' EXIT

# same remote as home/modules/nextcloud.nix, no rclone.conf
export RCLONE_CONFIG_NEXTCLOUD_TYPE=webdav
export RCLONE_CONFIG_NEXTCLOUD_URL="${NEXTCLOUD_URL:-http://lab:8080}/remote.php/dav/files/ak"
export RCLONE_CONFIG_NEXTCLOUD_VENDOR=nextcloud
export RCLONE_CONFIG_NEXTCLOUD_USER=ak

if [ ! -s "$SECRET" ]; then
	read -rsp "Nextcloud app password: " pw
	echo
	install -d -m700 "$(dirname "$SECRET")"
	(
		umask 077
		"$RCLONE" obscure "$pw" >"$SECRET"
	)
	unset pw
fi
RCLONE_CONFIG_NEXTCLOUD_PASS="$(<"$SECRET")"
export RCLONE_CONFIG_NEXTCLOUD_PASS

# emudeck's own paths, so a library on the sd card is followed
emudeck_path() {
	(
		set +eu
		# shellcheck source=/dev/null
		[ -f "$SETTINGS" ] && . "$SETTINGS" >/dev/null 2>&1
		echo "${!1:-$2}"
	)
}
declare -A DEST=(
	[roms]="$(emudeck_path romsPath "$HOME/Emulation/roms")"
	[bios]="$(emudeck_path biosPath "$HOME/Emulation/bios")"
)

if ! dirs="$("$RCLONE" lsf --dirs-only "${RCLONE_FLAGS[@]}" "$REMOTE")"; then
	echo "cannot list $REMOTE: lab unreachable, wrong app password (delete $SECRET) or no such folder." >&2
	exit 1
fi
for sub in roms bios; do
	grep -qx "$sub/" <<<"$dirs" || continue
	echo "$REMOTE/$sub -> ${DEST[$sub]}"
	"$RCLONE" copy "${RCLONE_FLAGS[@]}" --progress "$REMOTE/$sub" "${DEST[$sub]}"
done

echo "Done. ES-DE and DuckStation list new games on their next start; Steam ROM Manager adds them to Steam."
