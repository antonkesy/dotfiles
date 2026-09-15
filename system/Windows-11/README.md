# Windows-11

`bootstrap.ps1`: winget (bootstrapped via the `Microsoft.WinGet.Client` module if
App Installer is missing), then Chrome, Steam, Epic, Ubisoft Connect, Rockstar,
Discord and G HUB, then the Fanatec App from a pinned vendor zip because Fanatec
ships nothing to winget. Needs an elevated PowerShell; the Fanatec installer is
interactive. Reboot once after the first run.

Games box only: unlike the Linux systems this clones nothing and never runs
`make home`. When the pinned zip 404s, take the new link from
<https://www.fanatec.com/us/en/s/download-apps-driver> and bump `$FANATEC_URL`;
`$env:FANATEC_URL` overrides it for a single run.
