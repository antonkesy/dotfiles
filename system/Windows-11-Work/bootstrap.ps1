# irm https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Windows-11-Work/bootstrap.ps1 | iex
Set-StrictMode -Version 1.0
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$PACKAGES = @(
	'Google.Chrome',
	'Discord.Discord',
	'Alacritty.Alacritty'
)

$ME = [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not ([Security.Principal.WindowsPrincipal]$ME).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	throw 'run this from an elevated powershell.'
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
	Install-Module -Name Microsoft.WinGet.Client -Repository PSGallery -Scope AllUsers -Force
	Repair-WinGetPackageManager -Latest -Force
}
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
	throw 'winget is still missing: install App Installer from the Microsoft Store and re-run.'
}

foreach ($id in $PACKAGES) {
	winget list --exact --id $id --accept-source-agreements | Out-Null
	if ($LASTEXITCODE -eq 0) { continue }
	winget install --exact --id $id --source winget --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
	# 0x8a150062: installed, needs the reboot to finish
	if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335134) {
		throw "winget install $id failed ($LASTEXITCODE)"
	}
}

# alacritty reads %APPDATA%\alacritty on windows; its theme import stays ~/.config/...
# theme pinned to the home/.config/alacritty/themes submodule commit
$ALACRITTY_FILES = @{
	'https://raw.githubusercontent.com/antonkesy/dotfiles/main/home/.config/alacritty/alacritty.toml' = Join-Path $env:APPDATA 'alacritty\alacritty.toml'
	'https://raw.githubusercontent.com/alacritty/alacritty-theme/f82c742634b5e840731dd7c609e95231917681a5/themes/iterm.toml' = Join-Path $HOME '.config\alacritty\themes\themes\iterm.toml'
}
foreach ($url in $ALACRITTY_FILES.Keys) {
	$dest = $ALACRITTY_FILES[$url]
	New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null
	Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
}

Write-Host 'Done. Reboot.'
