# irm https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Windows-11/bootstrap.ps1 | iex
Set-StrictMode -Version 1.0
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$PACKAGES = @(
	'Google.Chrome',
	'Valve.Steam',
	'EpicGames.EpicGamesLauncher',
	'Ubisoft.Connect',
	'RockstarGames.Launcher',
	'Discord.Discord',
	'Logitech.GHUB',
	'Nextcloud.NextcloudDesktop'
)
# fanatec ships nothing to winget; current link on https://www.fanatec.com/us/en/s/download-apps-driver
$FANATEC_URL = if ($env:FANATEC_URL) { $env:FANATEC_URL } else { 'https://www3.corsair.com/Files/Fanatec/App/FanatecAppInstaller_v1_5_4_2.zip' }

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

$UNINSTALL = @(
	'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
	'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
	'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
)
if (-not (Get-ItemProperty $UNINSTALL -ErrorAction SilentlyContinue | Where-Object DisplayName -like '*Fanatec*')) {
	$zip = Join-Path $env:TEMP 'fanatec-app.zip'
	$dir = Join-Path $env:TEMP 'fanatec-app'
	Invoke-WebRequest -Uri $FANATEC_URL -OutFile $zip -UseBasicParsing
	Expand-Archive -Path $zip -DestinationPath $dir -Force
	$installer = Get-ChildItem $dir -Recurse -Include '*.exe', '*.msi' | Select-Object -First 1
	if (-not $installer) { throw "no installer in $FANATEC_URL" }
	if ((Get-AuthenticodeSignature $installer.FullName).Status -ne 'Valid') {
		throw "$($installer.FullName) is not signed: install the fanatec app by hand."
	}
	Write-Host 'the fanatec installer is interactive: click through it.'
	Start-Process -FilePath $installer.FullName -Wait
}

Write-Host 'Done. Reboot.'
