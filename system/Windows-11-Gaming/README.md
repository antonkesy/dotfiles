# Windows-11-Gaming

`bootstrap.ps1`: winget (bootstrapped via the `Microsoft.WinGet.Client` module
if App Installer is missing), then Chrome, Steam, Epic, Ubisoft Connect,
Rockstar, Discord, Alacritty, VS Code, G HUB, the Nextcloud client and
Tailscale, then the Alacritty config from `home/.config/alacritty` into
`~\.config\alacritty`, under a `%APPDATA%\alacritty\alacritty.toml` that imports
it with window decorations (all overwritten on every run), then the Fanatec App
from a pinned vendor zip because Fanatec ships nothing to winget, and last
Pi-hole on lab (`192.168.178.29`, `$env:PIHOLE` overrides it) as the only DNS
server of every connected physical adapter, with the IPv6 DNS the Fritz!Box
hands out (DHCPv6 and router advertisements) cleared, so the `*.antonkesy.de`
names resolve. Lab down means no DNS here: `Set-DnsClientServerAddress
-InterfaceIndex <n> -ResetServerAddresses` and `netsh interface ipv6 set
dnsservers <n> source=dhcp` undo it. Needs an
elevated PowerShell; the Fanatec installer is interactive. Reboot once after the
first run.

Games box only: unlike the Linux systems this clones nothing and never runs
`make home`; the Alacritty config comes from `main` on GitHub, its theme from
the commit pinned in the script (bump it with the `themes` submodule). When the
pinned zip 404s, take the new link from
<https://www.fanatec.com/us/en/s/download-apps-driver> and bump `$FANATEC_URL`;
`$env:FANATEC_URL` overrides it for a single run.
