# Windows-11-Work

`bootstrap.ps1`: winget (bootstrapped via the `Microsoft.WinGet.Client` module
if App Installer is missing), then Chrome, Discord and Alacritty, then the
Alacritty config from `home/.config/alacritty` (overwritten on every run). Needs
an elevated PowerShell. Reboot once after the first run.

Unlike the Linux systems this clones nothing and never runs `make home`; the
Alacritty config comes from `main` on GitHub, its theme from the commit pinned
in the script (bump it with the `themes` submodule).
