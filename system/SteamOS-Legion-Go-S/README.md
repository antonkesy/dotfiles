# SteamOS-Legion-Go-S

`bootstrap.sh` installs, in this order:

| what            | for                                              | from                                   | lives in                                | Steam shortcut |
| --------------- | ------------------------------------------------ | -------------------------------------- | --------------------------------------- | -------------- |
| Chrome          | browser                                          | Flathub, `--user`                      | `~/.local/share/flatpak`                | yes            |
| Heroic          | Epic, GOG and Amazon games                       | Flathub, `--user`                      | `~/.local/share/flatpak`                | yes            |
| Ludusavi        | save game backups                                | Flathub, `--user`                      | `~/.local/share/flatpak`                | yes            |
| Protontricks    | winetricks for Proton prefixes                   | Flathub, `--user`, plus `/run/media`   | `~/.local/share/flatpak`                | no             |
| Decky Loader    | plugins in the Gaming Mode Quick Access menu     | upstream `install_release.sh`, sudo    | `~/homebrew`, `plugin_loader` unit      | --             |
| ProtonDB Badges | ProtonDB rating on game pages (Decky plugin)     | Decky store zip, sha256-checked        | `~/homebrew/plugins/protondb-decky`     | --             |
| EmuDeck         | sets up and updates emulators                    | latest x86_64 AppImage from GitHub     | `~/Applications/EmuDeck.AppImage`       | yes            |
| DuckStation     | PS1 emulator                                     | `latest` x64 AppImage from GitHub      | `~/Applications/DuckStation.AppImage`   | yes            |
| rclone          | talks to Nextcloud for `nextcloud-games`         | downloads.rclone.org, sha256-checked   | `~/.local/bin/rclone`                   | --             |
| Nextcloud Games | copies new ROMs and BIOS files from Nextcloud    | `nextcloud-games.sh` on `main`         | `~/.local/bin/nextcloud-games`          | yes            |
| sshd            | `ssh deck@<host>` from the other machines        | ships with SteamOS, enabled            | `sshd` unit, `~/.ssh/authorized_keys`   | --             |

Protontricks gets `/run/media` so it sees SD card libraries. Shortcuts are added
via `steamos-add-to-steam` on first install only, so re-runs add no duplicates;
that needs Steam running, which Desktop Mode has.

Run it from Konsole in Desktop Mode after setting a password with `passwd` (the
`deck` user has none, and Decky needs sudo). Open EmuDeck once afterwards: its
setup wizard is interactive and installs the other emulators. DuckStation sits
at the path EmuDeck uses for it, so the wizard configures and updates that copy
instead of adding a second one; keep it selected there.

## SSH

`sshd` is enabled and started, and every key on
<https://github.com/antonkesy.keys> is added to `~/.ssh/authorized_keys`; keys
already there stay, so one removed from GitHub has to be removed here by hand.
Password login stays on as SteamOS ships it, with the `deck` password from
`passwd`. Log in as `deck`, not `ak`.

## Games from Nextcloud

Put games in Nextcloud under `Emulation/`, laid out like EmuDeck's
`~/Emulation`: `Emulation/roms/psx/<game>.chd`, `Emulation/roms/<system>/...`
for the rest, BIOS files (`scph5501.bin` for DuckStation) in `Emulation/bios`.
Then start Nextcloud Games from the Steam library, in Gaming Mode too. It opens
Konsole, copies whatever is new into EmuDeck's `romsPath` and `biosPath` (read
from `~/.config/EmuDeck/settings.sh`, so a library on the SD card works), and
closes after 30 seconds. ES-DE and DuckStation show the new games on their next
start; Steam ROM Manager (EmuDeck, Desktop Mode) turns them into Steam tiles.

The first run asks for a Nextcloud app password and stores it obscured in
`~/.config/rclone/nextcloud-app-password`, the same file the other machines
use. A wrong one: delete that file and run again. It talks to
`http://lab:8080` like `home/modules/nextcloud.nix`, so it needs the home
network.

It only copies, never deletes, on either side. A game deleted on the device to
free space comes back on the next run unless it is gone from Nextcloud too.

## Re-runs and updates

Re-running skips what is there, so it never updates the Flatpaks (`flatpak update
--user`, or Discover), Decky (its own settings page) or rclone (`rclone
selfupdate`). It does reinstall Decky if `plugin_loader` is not running,
ProtonDB Badges when the store has a newer version, and `nextcloud-games` every
time. EmuDeck updates itself and the emulators, DuckStation included.

Games box only: like Windows-11-Gaming this clones nothing and never runs
`make home`. The root is read-only, so nothing goes through pacman; everything
lives in `$HOME` except the enabled `sshd` and Decky's `plugin_loader` unit,
which SteamOS keeps across updates. A SteamOS update can still drop Decky from the Quick Access
menu: re-run the script.
