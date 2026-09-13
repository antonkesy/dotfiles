# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![ansible](https://github.com/antonkesy/dotfiles/workflows/ansible/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/ansible.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

Automated setup for my various Linux machines:

- **Home** (`home/`):
  Uses [Home Manager](https://github.com/nix-community/home-manager) to create me a reproducible terminal for my use on Arch and WSL2.
- **System** (`system/<Distro>/`): Automatically installs system specific packages.

<img src="./docs/images/preview.png" width="800">

## TL;DR

Every path clones this repo into `~/Projects/dotfiles` (load-bearing: home-manager links
`~/.config` into it) and ends in `homeConfigurations.ak`.

**Arch**
```bash
# phase 1, on the live ISO
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/install.sh | bash
# phase 2, after the reboot and first login
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
```

**Ubuntu-26.04 on WSL2**
```bash
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Ubuntu-26.04-WSL2/bootstrap.sh | bash
```

## Arch

Write the install ISO to a USB stick:

```bash
# 1. download the latest ISO
curl -LO https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso

# 2. find the stick -- pick the whole disk (e.g. sdX), not a partition (sdX1)
lsblk -d -o NAME,SIZE,MODEL,TRAN

# 3. make sure it is not mounted, then write the image
sudo umount /dev/sdX* 2>/dev/null
sudo dd if=archlinux-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Boot it, then:

```bash
# skip this block if connected with Ethernet
iwctl
station list                              # if required to find your wifi device
station wlan0 connect <your_wifi_ssid>
exit

# phase 1: archinstall with system/Arch/archinstall.json (GRUB, locale, NetworkManager,
# zram, the packages phase 2 needs). Set Disk configuration (+ encryption) and
# Authentication (root password, user ak with sudo) in the menu, then Install.
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/install.sh | bash

# reboot, pull the stick, log in as the new user

# skip this block if connected with Ethernet
nmcli radio wifi on
nmcli device wifi list
nmcli device wifi connect "<SSID>" --ask

# phase 2: ansible (system half, every role) then home-manager
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
```

Roles, the container test and the manual steps (`hyprpm`, fingerprints):
[`system/Arch/README.md`](system/Arch/README.md).

## WSL

WSL needs `[boot] systemd=true` in `/etc/wsl.conf` for the user services (ssh-agent,
gpg-agent); `system/Ubuntu-26.04-WSL2/bootstrap.sh` writes it once, then run
`wsl --shutdown` from Windows. Details: [`system/Ubuntu-26.04-WSL2/README.md`](system/Ubuntu-26.04-WSL2/README.md).

## Targets

| target | what it does |
| --- | --- |
| `make home` | build + activate `homeConfigurations.ak` |
| `make arch` | system half of an Arch machine (ansible, every role) |
| `make wsl` | system half of Ubuntu on WSL2, then switch (re-runnable) |
| `make clean` | build outputs, user-level nix garbage, AUR builds |
| `make use-ssh` | switch origin remote (and submodules) from https to ssh |

## Currently used with

- Arch / Ubuntu on WSL
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://www.zsh.org/) + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](http://lazyvim.org/)
- [Hyprland](https://hyprland.org/) + [DankMaterialShell](https://danklinux.com/)

## Workarounds

### `gcr-ssh-agent` spamming processes at 99% CPU

The plain ssh-agent is used everywhere (`services.ssh-agent` here), listening on
`$XDG_RUNTIME_DIR/ssh-agent`, which is what `home/.config/zsh/path.zsh` and
`home/.config/hypr/hyprland.lua` point `SSH_AUTH_SOCK` at. If a key is still ignored, its permissions are
too open:

```bash
chmod 600 ~/.ssh/<key>
```

### Rolling back

```bash
home-manager generations          # pick one, run its activate script
```
