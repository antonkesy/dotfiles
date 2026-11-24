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

Protontricks gets `/run/media` so it sees SD card libraries. Shortcuts are added
via `steamos-add-to-steam` on first install only, so re-runs add no duplicates;
that needs Steam running, which Desktop Mode has.

Run it from Konsole in Desktop Mode after setting a password with `passwd` (the
`deck` user has none, and Decky needs sudo). Open EmuDeck once afterwards: its
setup wizard is interactive and installs the emulators themselves, the script
installs none.

## Re-runs and updates

Re-running skips what is there, so it never updates the Flatpaks (`flatpak update
--user`, or Discover) or Decky (its own settings page). It does reinstall Decky
if `plugin_loader` is not running, and ProtonDB Badges when the store has a newer
version. EmuDeck updates itself and the emulators.

Games box only: like Windows-11-Gaming this clones nothing and never runs
`make home`. The root is read-only, so nothing goes through pacman; everything
lives in `$HOME` except Decky's `plugin_loader` unit, which SteamOS keeps
across updates. A SteamOS update can still drop Decky from the Quick Access
menu: re-run the script.
