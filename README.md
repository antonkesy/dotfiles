# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![ansible](https://github.com/antonkesy/dotfiles/workflows/ansible/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/ansible.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

One repo, two halves:

- **Home** (repo root): everything under `~` as a
  [Home Manager](https://github.com/nix-community/home-manager) flake -- the same `zsh`,
  `tmux`, `nvim`, `git`, CLI tools and language toolchains on `Arch` and `Ubuntu(WSL2)`,
  plus the Hyprland/DankMaterialShell config (linked everywhere, used on the desktops).
- **System** (`system/<Distro>/`): what needs root. On Arch an `archinstall` answer file
  and an ansible playbook (packages, drivers, daemons, PAM, the login session, GUI apps);
  on Ubuntu/WSL2 a short bootstrap script (apt, `/etc/wsl.conf`, single-user nix). Both
  end by running `make switch` from this checkout.

<img src="./docs/images/preview.png" width="800">

## TL;DR

Every path clones this repo into `~/Projects/dotfiles` (load-bearing: home-manager links
`~/.config` into it) and ends in `homeConfigurations.ak`.

**Arch**
```bash
# phase 1, on the live ISO (hostname = ansible profile: akdesk, aklap, ak)
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/install.sh | bash -s -- akdesk
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
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/install.sh | bash -s -- akdesk

# reboot, pull the stick, log in as the new user

# skip this block if connected with Ethernet
nmcli radio wifi on
nmcli device wifi list
nmcli device wifi connect "<SSID>" --ask

# phase 2: ansible (system half) then home-manager; HOST=ak for the generic profile
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
```

Roles, profiles, the container test and the manual steps (`hyprpm`, fingerprints):
[`system/Arch/README.md`](system/Arch/README.md).

## WSL

WSL needs `[boot] systemd=true` in `/etc/wsl.conf` for the user services (ssh-agent,
gpg-agent); `system/Ubuntu-26.04-WSL2/bootstrap.sh` writes it once, then run
`wsl --shutdown` from Windows. Details: [`system/Ubuntu-26.04-WSL2/README.md`](system/Ubuntu-26.04-WSL2/README.md).

## Targets

| target | what it does |
| --- | --- |
| `make switch` | build + activate `homeConfigurations.ak` |
| `make dry` | show what switch would do |
| `make build` | build without activating |
| `make check` | evaluate the flake |
| `make update` | update flake inputs |
| `make clean` | remove build outputs, user-level garbage collection, `system/Arch/build` |
| `make use-ssh` | switch origin remote (and submodules) from https to ssh |
| `make arch` | ansible playbook for profile `HOST` (default: hostname) |
| `make ansible-check` | dry run of the playbook on this machine |
| `make ansible-syntax` / `make lint` | playbook syntax check / ansible-lint |
| `make test-arch` / `make dev-arch` | `ansible --check` inside the Arch container / a shell in it |
| `make wsl` | the Ubuntu/WSL2 bootstrap (re-runnable) |

## Layout

```
flake.nix, lib/, modules/home/   Home Manager flake: homeConfigurations.ak
home/                            the plain dotfiles it links into ~ (stow-style)
system/Arch/                     archinstall.json, install.sh, bootstrap.sh, ansible/, docker/, manual/
system/Ubuntu-26.04-WSL2/        bootstrap.sh
scripts/use-ssh-remote.sh        make use-ssh
```

## Currently used with

- Arch / Ubuntu on WSL
- [tmux](https://github.com/tmux/tmux/wiki) + zsh + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](http://lazyvim.org/)
- [Hyprland](https://hyprland.org/) + [DankMaterialShell](https://danklinux.com/) -- installed by `system/Arch`'s ansible, configured here

## Linked, not generated

The dotfiles under `home/` stay plain files (`.zshrc` + zinit, `.tmux.conf` + TPM,
`alacritty.toml`, `lazygit/config.yml`, the nvim submodule, the hypr lua); Home Manager only
symlinks them into the checkout: `.zshrc`, `.tmux.conf`, `.tmux/plugins/tpm`, `zsh/`,
`alacritty/`, `lazygit/config.yml` (`modules/home/dotfiles.nix`), `nvim/`
(`modules/home/nvim.nix`) and the Hyprland/DMS config (`modules/home/desktop.nix`).

## Hyprland / DMS config

`modules/home/desktop.nix` handles `home/.config/{hypr,DankMaterialShell,wallpapers}` in
three tiers, because DankMaterialShell rewrites its own config at runtime. It is applied on
every machine (WSL included, where it is simply unused) so that all of `~` comes from here.

| tier | what | how |
|---|---|---|
| **linked** -- symlink into the checkout | `hypr/hyprland.lua`, `hypr/plugins.lua`, `hypr/dms/binds-user.lua`, `hypr/dms/windowrules.lua`, `hypr/scripts/*`, `wallpapers/` | `xdg.configFile`, out of store |
| **seeded** -- copied once, then yours | `DankMaterialShell/{settings,clsettings,plugin_settings}.json`, `hypr/dms/{binds,colors,layout}.lua`, `discord/settings.json`, `DankMaterialShell/.firstlaunch` | activation script, only when absent |
| **left alone** -- machine-specific state | `DankMaterialShell/monitors.json`, `hypr/dms/{outputs,cursor}.lua`, `hypr/dms/profiles/` | nothing declares these (gitignored) |

`~/.config/hypr` is linked file by file: a *single file* symlink leaves its parent directory
writable, which is what lets DMS keep generating files next to the linked ones. Seeds are only
written when the target is absent, so live DMS state always wins over the repo copy -- to
re-apply an updated repo version, delete the file and `make switch`. Hyprland plugins are
installed with `hyprpm` (`system/Arch/manual/hyprpm.sh`).

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
