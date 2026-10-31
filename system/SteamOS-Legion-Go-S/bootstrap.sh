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
	mkdir -p "$(dirname "$EMUDECK")"
	curl -fL "$url" -o "$EMUDECK.part"
	chmod +x "$EMUDECK.part"
	mv "$EMUDECK.part" "$EMUDECK"
	add_to_steam "$EMUDECK"
fi

echo "Done. Run EmuDeck once for its setup wizard, then switch to Gaming Mode (Decky is in the Quick Access menu)."
