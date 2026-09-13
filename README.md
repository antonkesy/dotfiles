# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

Everything under `~` as a [Home Manager](https://github.com/nix-community/home-manager)
flake: the same `zsh`, `tmux`, `nvim`, `git`, CLI tools and language toolchains on `Arch`
and `Ubuntu(WSL2)`, plus the Hyprland/DankMaterialShell config (linked everywhere, used
on the desktops).

Packages that need root or the GPU (drivers, daemons, the compositor stack, GUI apps) are
installed separately by the ansible playbook in [`setup`](https://github.com/antonkesy/setup);
that playbook ends by running `home-manager switch` from this repo.

<img src="./docs/images/preview.png" width="800">

## TL;DR

**Ubuntu-26.04 on WSL2**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/scripts/bootstrap-wsl.sh)"
```

**Arch**
```bash
# skip this block if connected with Ethernet
iwctl
station list # if required to find your wifi device
station wifi connect <your_wifi_ssid>
exit

# get archinstall.json
curl -L https://raw.githubusercontent.com/antonkesy/dotfiles/main/arch_install_config.json -o arch_install_config.json
# setup all missing parts: partitioning & authentication
archinstall --config arch_install_config.json
# Manually set: Partitioning (+ HW Encryption), Root PW, User Accounts

# Reboot and login into new user

# skip this block if connected with Ethernet
nmcli radio wifi on
nmcli device wifi list
nmcli device wifi connect "<SSID>" --ask

# some setups might assume position of dotfiles in ~/workspace
sh -c "$(curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/scripts/bootstrap-arch.sh)"
```

## Prerequisites

### Arch

Write the install ISO to a USB stick, boot and install following [TL;DR](#tldr):

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

WSL needs `[boot] systemd=true` in `/etc/wsl.conf` for the user services (ssh-agent,
gpg-agent); `setup`'s Ubuntu bootstrap writes it.

## Targets

| target        | what it does                                        |
| ------------- | --------------------------------------------------- |
| `make switch` | build + activate `homeConfigurations.ak`            |
| `make dry`    | show what switch would do                           |
| `make build`  | build without activating                            |
| `make check`  | evaluate the flake                                  |
| `make update` | update flake inputs                                 |
| `make clean`  | remove build outputs, user-level garbage collection |

## Currently used with

- Arch / Ubuntu on WSL
- [tmux](https://github.com/tmux/tmux/wiki) + zsh + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](http://lazyvim.org/)
- [Hyprland](https://hyprland.org/) + [DankMaterialShell](https://danklinux.com/) -- installed by `setup`, configured here

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
installed with `hyprpm` (`setup/distros/Arch/manual/hyprpm.sh`).

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
