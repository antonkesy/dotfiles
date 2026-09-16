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

Copy `~/.ssh` over and import the gpg key; the first `git push` / signed commit
asks for each passphrase once, see *Keys*.

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

## Keys

The SSH and GPG keys are the one thing this repo cannot carry, and nothing in it
installs them: copy `~/.ssh` and `~/.gnupg` across by hand, or re-import the gpg key
from a backup, then fix the modes -- `0700` on the directories, `0600` on the private
keys. Leave `gpg.conf` and `gpg-agent.conf` alone, home-manager owns those and
rewrites them on every `make home`.

### Keys unlocked at login

`gpg-agent` (home-manager, `home/modules/git.nix`) caches the passphrase and prompts
through `pinentry-gnome3`, in its own window rather than over a TUI. The first
`git push` and the first signed commit after a login ask once each; `commit.gpgsign`
is on, so a missing signing key only shows up as a failure at the first commit --
`git config user.signingkey` says which one `git.nix` expects.

## Nextcloud

`~/Nextcloud` is a streamed WebDAV mount of `http://lab:8080`, not a sync folder --
`home/modules/nextcloud.nix`, no desktop client. Like the keys, the app password is
not in this repo, and without it the mount stays skipped:

```bash
install -d -m700 ~/.config/rclone && read -s "pw?Nextcloud app password: " && echo && rclone obscure "$pw" > ~/.config/rclone/nextcloud-app-password && unset pw && chmod 600 ~/.config/rclone/nextcloud-app-password```

Store it obscured: rclone misreads an app password as already-obscured otherwise.

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
