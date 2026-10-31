# SteamOS-Legion-Go-S

`bootstrap.sh`: Chrome, Heroic, Ludusavi and Protontricks from Flathub
(`--user`; Protontricks also gets `/run/media` for SD card libraries), then
Decky Loader through its upstream installer, then the ProtonDB Badges plugin
straight from the Decky store (sha256-checked, reinstalled when the store has a
newer version), then the EmuDeck AppImage into `~/Applications`. Chrome, Heroic,
Ludusavi and EmuDeck are added to Steam as non-Steam shortcuts via
`steamos-add-to-steam` on their first install only, so re-runs add no
duplicates; that needs Steam running, which Desktop Mode has. Run it from
Konsole in Desktop Mode after setting a password with `passwd` (the `deck` user
has none, and Decky needs sudo). Open EmuDeck once afterwards: its setup wizard
is interactive and from then on manages the emulators and its own updates.

Games box only: like Windows-11-Gaming this clones nothing and never runs
`make home`. The root is read-only, so nothing goes through pacman; everything
lives in `$HOME` except Decky's `plugin_loader` unit, which SteamOS keeps
across updates. A SteamOS update can still drop Decky from the Quick Access
menu: re-run the script.
