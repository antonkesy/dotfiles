# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![ansible](https://github.com/antonkesy/dotfiles/workflows/ansible/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/ansible.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

Automated setup for my various Linux machines:

- **Home** (`home/`):
  Uses [Home Manager](https://github.com/nix-community/home-manager) to create me a reproducible terminal for my use on Arch and WSL2.
- **System** (`system/<Distro>/`): Automatically installs system specific packages.
  - Arch: [Ansible](https://github.com/ansible/ansible).
  - Ubuntu-26.04 in WSL2: Shell script.

<img src="./docs/images/preview.png" width="800">

## TL;DR

Every path clones this repo into `~/Projects/dotfiles` (load-bearing: home-manager links
`~/.config` into it) and ends in `homeConfigurations.ak`.

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

# after reboot final (manual) steps
hyprpm update
```

**Ubuntu-26.04 on WSL2**

```bash
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Ubuntu-26.04-WSL2/bootstrap.sh | bash
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

The plain ssh-agent is used everywhere (`services.ssh-agent` here), listening on
`$XDG_RUNTIME_DIR/ssh-agent`, which is what `home/.config/zsh/path.zsh` and
`home/.config/hypr/hyprland.lua` point `SSH_AUTH_SOCK` at. If a key is still ignored, its permissions are
too open:

```bash
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

### Rolling back

```bash
home-manager generations          # pick one, run its activate script
```

### WSL Install Not Working

If you get:

```bash
E: Release file for http://archive.ubuntu.com/ubuntu/dists/resolute-updates/InRelease is not valid yet (invalid for another 1h 9min 10s). Updates for this repository will not be applied.
```

Check if your Windows time is up-to-date and sync if necessary.
