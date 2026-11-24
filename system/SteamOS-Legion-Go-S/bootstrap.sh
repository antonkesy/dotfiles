#!/bin/bash
# curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/SteamOS-Legion-Go-S/bootstrap.sh | bash
set -euo pipefail

# read-only root: everything lands in $HOME, decky's unit in /etc survives updates
APPS=(
	com.google.Chrome
	com.heroicgameslauncher.hgl
	com.github.mtkennerly.ludusavi
	com.github.Matoking.protontricks
)
# installed but not added to steam
NO_SHORTCUT=(com.github.Matoking.protontricks)
DECKY_INSTALLER=https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh
DECKY_STORE=https://plugins.deckbrew.xyz/plugins
DECKY_CDN=https://cdn.tzatzikiweeb.moe/file/steam-deck-homebrew/versions
PLUGINS="$HOME/homebrew/plugins"
EMUDECK="$HOME/Applications/EmuDeck.AppImage"
# emudeck's own path, so its wizard updates this one instead of adding a second
DUCKSTATION="$HOME/Applications/DuckStation.AppImage"
DUCKSTATION_URL=https://github.com/stenzek/duckstation/releases/download/latest/DuckStation-x64.AppImage
RCLONE="$HOME/.local/bin/rclone"
GAMES_SYNC="$HOME/.local/bin/nextcloud-games"
GAMES_SYNC_URL=https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/SteamOS-Legion-Go-S/nextcloud-games.sh
GAMES_DESKTOP="$HOME/.local/share/applications/nextcloud-games.desktop"
FLATPAK_APPS="${XDG_DATA_HOME:-$HOME/.local/share}/flatpak/exports/share/applications"

if ! grep -qx 'ID=steamos' /etc/os-release; then
	echo "not SteamOS: see system/ for the other machines." >&2
	exit 1
fi
if [ "$(passwd -S "$USER" | cut -d' ' -f2)" = NP ]; then
	echo "no password set: run 'passwd' first, sudo needs it." >&2
	exit 1
fi
sudo -v

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# needs a running steam (desktop mode has one); shows up in gaming mode
add_to_steam() {
	steamos-add-to-steam "$1" </dev/null || echo "adding $1 to steam failed: add it by hand."
}

fetch_exe() {
	mkdir -p "$(dirname "$2")"
	curl -fL "$1" -o "$2.part"
	chmod +x "$2.part"
	mv "$2.part" "$2"
}

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for id in "${APPS[@]}"; do
	flatpak info "$id" >/dev/null 2>&1 && continue
	flatpak install --user -y --noninteractive flathub "$id" </dev/null
	# only on a fresh install, re-runs would add duplicates
	[[ " ${NO_SHORTCUT[*]} " == *" $id "* ]] || add_to_steam "$FLATPAK_APPS/$id.desktop"
done
# games on the sd card
flatpak override --user --filesystem=/run/media com.github.Matoking.protontricks

if ! systemctl is-active --quiet plugin_loader; then
	curl -fsSL "$DECKY_INSTALLER" -o "$TMP/decky.sh"
	# bash, not sh: the installer needs $SUDO_USER and uses bashisms
	sudo bash "$TMP/decky.sh" </dev/null
fi

read -r PDB_VERSION PDB_HASH < <(curl -fsSL "$DECKY_STORE" |
	jq -r '.[] | select(.name == "ProtonDB Badges") | .versions[0] | "\(.name) \(.hash)"') ||
	{
		echo "ProtonDB Badges not found in the decky store." >&2
		exit 1
	}
if [ "$(jq -r .version "$PLUGINS/protondb-decky/package.json" 2>/dev/null)" != "$PDB_VERSION" ]; then
	curl -fsSL "$DECKY_CDN/$PDB_HASH.zip" -o "$TMP/protondb.zip"
	echo "$PDB_HASH  $TMP/protondb.zip" | sha256sum -c --quiet
	python3 -m zipfile -e "$TMP/protondb.zip" "$TMP/protondb"
	sudo rm -rf "$PLUGINS/protondb-decky"
	sudo mv "$TMP/protondb/protondb-decky" "$PLUGINS/"
	sudo systemctl restart plugin_loader
fi

# same release upstream install.sh fetches, minus its zenity ui
if [ ! -e "$EMUDECK" ]; then
	url="$(curl -fsSL https://api.github.com/repos/EmuDeck/emudeck-electron/releases/latest |
		jq -r 'first(.assets[] | select(.name | endswith(".AppImage")) | select(.name | test("arm64") | not)) | .browser_download_url')"
	fetch_exe "$url" "$EMUDECK"
	add_to_steam "$EMUDECK"
fi

if [ ! -e "$DUCKSTATION" ]; then
	fetch_exe "$DUCKSTATION_URL" "$DUCKSTATION"
	add_to_steam "$DUCKSTATION"
fi

if [ ! -x "$RCLONE" ]; then
	v="$(curl -fsSL https://downloads.rclone.org/version.txt | sed 's/^rclone //')"
	zip="rclone-$v-linux-amd64.zip"
	(
		cd "$TMP"
		curl -fsSL "https://downloads.rclone.org/$v/$zip" -o "$zip"
		curl -fsSL "https://downloads.rclone.org/$v/SHA256SUMS" | grep "  $zip\$" | sha256sum -c --quiet
	)
	python3 -m zipfile -e "$TMP/$zip" "$TMP"
	install -Dm755 "$TMP/${zip%.zip}/rclone" "$RCLONE"
fi

# every run, so it follows main
curl -fsSL "$GAMES_SYNC_URL" -o "$TMP/nextcloud-games"
install -Dm755 "$TMP/nextcloud-games" "$GAMES_SYNC"
if [ ! -e "$GAMES_DESKTOP" ]; then
	mkdir -p "$(dirname "$GAMES_DESKTOP")"
	cat >"$GAMES_DESKTOP" <<EOF
[Desktop Entry]
Type=Application
Name=Nextcloud Games
Comment=Copy new ROMs and BIOS files from Nextcloud
Exec=konsole -e $GAMES_SYNC
Icon=folder-cloud
Terminal=false
EOF
	add_to_steam "$GAMES_DESKTOP"
fi

echo "Done. Run EmuDeck once for its setup wizard (keep DuckStation selected), then switch to Gaming Mode (Decky is in the Quick Access menu)."
