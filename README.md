# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![ansible](https://github.com/antonkesy/dotfiles/workflows/ansible/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/ansible.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

Automated setup for my various machines:

- **Home** (`home/`):
  Uses [Home Manager](https://github.com/nix-community/home-manager) to create me a reproducible terminal for my use on Arch and WSL2.
- **System** (`system/<System>/`): Automatically installs system specific packages.
  - Arch: [Ansible](https://github.com/ansible/ansible).
  - Ubuntu-26.04 in WSL2: Shell script.
  - Windows 11: PowerShell script. Games box, no `home/` half.

<img src="./docs/images/preview.png" width="800">

## TL;DR

Every Linux path clones this repo into `~/Projects/dotfiles` (load-bearing: home-manager
links `~/.config` into it) and ends in `homeConfigurations.ak`. Windows does neither.

**Arch**

```bash
# skip this block if connected with Ethernet
iwctl
station list                              # if required to find your wifi device
station wlan0 connect <your_wifi_ssid>
exit

# phase 1: archinstall with system/Arch/archinstall.json (GRUB, locale, NetworkManager,
# zram, the packages phase 2 needs). Set Disk configuration (+ encryption) and
# Authentication (root password, user ak with sudo) in the menu, then Install.
curl -fsSLO https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/archinstall.json
archinstall --config archinstall.json

# reboot, pull the stick, log in as the new user

# skip this block if connected with Ethernet
nmcli radio wifi on
nmcli device wifi list
nmcli device wifi connect "<SSID>" --ask

# phase 2: ansible (system half, every role) then home-manager
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
```

Copy `~/.ssh` and import the gpg key; the first `git push` / signed commit asks
for each passphrase once, see *Keys unlocked at login*. Put the NAS Samba
password in `/etc/nas/credentials`, see *NAS shares*.

**Ubuntu-26.04 on WSL2**

```bash
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Ubuntu-26.04-WSL2/bootstrap.sh | bash
```

**Windows 11**

```powershell
# Win+X > Terminal (Admin)
irm https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Windows-11/bootstrap.ps1 | iex
```

## Perquisites

### Arch

Write the install ISO to a USB stick and boot:

```bash
# 1. download the latest ISO
curl -LO https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso
# 2. find the stick -- pick the whole disk (e.g. sdX), not a partition (sdX1)
lsblk -d -o NAME,SIZE,MODEL,TRAN
# 3. make sure it is not mounted, then write the image
sudo umount /dev/sdX* 2>/dev/null
sudo dd if=archlinux-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### WSL

```bash
wsl --install -d Ubuntu-26.04
wsl
# setup user with name `ak`
```

## Targets

| target         | what it does                                             |
| -------------- | -------------------------------------------------------- |
| `make home`    | build + activate `homeConfigurations.ak`                 |
| `make arch`    | system half of an Arch machine (ansible, every role)     |
| `make wsl`     | system half of Ubuntu on WSL2, then switch (re-runnable) |
| `make clean`   | build outputs, user-level nix garbage, AUR builds        |
| `make use-ssh` | switch origin remote (and submodules) from https to ssh  |

## NAS shares

`//192.168.178.26/{Music,Movies,ak}` are SMB3.1.1 mounts at `/mnt/nas/*`. The `storage`
role writes `noauto,user` entries into `/etc/fstab`, so nothing mounts at boot;
`nas-mount.service` (`home/modules/nas.nix`) mounts them when `graphical-session.target`
comes up and unmounts them at logout. The shares only exist while you are logged in.

The password is the one secret this repo does not carry. `make arch` seeds a placeholder:

```bash
sudoedit /etc/nas/credentials     # username=ak / password=<samba password>
systemctl --user restart nas-mount.service
```

`/etc/nas/credentials` is `0600 root:root`. `/usr/bin/mount.cifs` is setuid root and
raises `CAP_DAC_READ_SEARCH` to read it on your behalf, which is why an unprivileged
`mount /mnt/nas/ak` works without ever exposing the password to your user. The flip
side: the `user` fstab flag lets *any* local account trigger that mount -- though
`file_mode=0600` / `dir_mode=0700` still keep them out of the contents. Single-user
box, acceptable.

`user` also forces `noexec,nosuid,nodev`, so you cannot run a binary or script
straight off the share. Copy it locally first.

The NAS still offers the same folders over unauthenticated NFS to the whole LAN; this
half only stops *this machine* from using it. Turning the NFS server off lives in the
appliance web UI.

## Currently used with

- Arch / Ubuntu on WSL
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://www.zsh.org/) + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](http://lazyvim.org/)
- [Hyprland](https://hyprland.org/) + [DankMaterialShell](https://danklinux.com/)

## DMS plugins

`home/.config/DankMaterialShell/plugins.lock.json` pins every plugin to a commit and
is tracked; the clones under `plugins/` are gitignored. `make home` re-clones the
ones a machine is missing, and `plugin_settings.json` / `settings.json` enable them.

```bash
dms plugins install <id>   # or the DMS settings GUI; rewrites the lockfile
dms plugins update         # then commit the lockfile
```

## Workarounds & Possible Fixes

### `gcr-ssh-agent` spamming processes at 99% CPU

A private key it cannot read is retried in a loop. Its permissions are too open:

```bash
journalctl --user -u gcr-ssh-agent.service -b
chmod 600 ~/.ssh/<key>
```

### DMS does not start after login

DMS runs as `dms.service`, which uwsm pulls in via `graphical-session.target`.

```bash
systemctl --user is-active graphical-session.target   # inactive -> not a uwsm session
systemctl --user status dms.service
journalctl --user -u dms.service -b
```

The AUR package `dms` is a DLNA server, not DankMaterialShell, and owns the same
`/usr/bin/dms`. If it is still installed, `sudo pacman -Rns dms` before `make arch`.

### `yay` fails with a `libalpm.so` error

`yay` is built from source (the AUR `yay`, not `yay-bin`) against the pacman of
the day, so a pacman update can leave it stale:

```
yay: error while loading shared libraries: libalpm.so.XX: cannot open shared object file
```

`make arch` skips anything `pacman -Q` already reports, so it will not rebuild
yay on its own. Remove it first and let ansible build it again:

```bash
sudo pacman -Rns yay && make arch
```

### WSL Install Not Working

If you get:

```bash
E: Release file for http://archive.ubuntu.com/ubuntu/dists/resolute-updates/InRelease is not valid yet (invalid for another 1h 9min 10s). Updates for this repository will not be applied.
```

Check if your Windows time is up-to-date and sync if necessary.
