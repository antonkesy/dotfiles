# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

A standalone [Home Manager](https://github.com/nix-community/home-manager) flake:
every user-level program and every dotfile, on any Linux distro. What Home Manager
cannot do without root -- NixOS system config, drivers, the compositor stack, daemons --
lives in the sibling repo [`setup`](https://github.com/antonkesy/setup).

<img src="./docs/images/preview.png" width="800">

## Hosts

One `homeConfigurations.<host>` per file in `hosts/`; each is just a set of feature flags.

| host | distro | desktop | development | containers | nvidia |
|---|---|---|---|---|---|
| `akdesk` | NixOS (system half in `setup`) | x | x | x | x (CUDA userspace) |
| `aklap` | NixOS (system half in `setup`) | x | x | x | |
| `ak` | any other distro with a desktop (Arch) | x | x | x | pin driver libs, see `hosts/ak.nix` |
| `wsl` | Ubuntu on WSL2 | | x | x | |

`ak.nixos` is detected, not configured: as a NixOS module (imported by `setup`) the
system owns ssh-agent, keyring, GL drivers and the session; standalone, this flake
enables the generic-Linux shims (`targets.genericLinux`) instead.

## Fresh machine (Arch, Ubuntu, WSL)

`~/Projects/dotfiles` is load-bearing (`ak.dotfilesDir`): `modules/home/dotfiles.nix`
and `nvim.nix` symlink the files under `home/` straight into the checkout, so lazy.nvim,
tpm and zinit can write next to them and edits apply without a rebuild.

```bash
# 1. nix (multi-user, flakes on) -- or let setup's ansible do all of this
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. clone and switch
mkdir -p ~/Projects && cd ~/Projects
git clone --recursive https://github.com/antonkesy/dotfiles.git
cd dotfiles
make switch                      # HOST defaults to `hostname`; HOST=ak / HOST=wsl to pick one

# 3. desktop hosts only: OpenGL for Nix-built apps (once, and after GL lib updates)
sudo ~/.nix-profile/bin/non-nixos-gpu-setup
```

The first `make switch` runs home-manager from this flake's pinned input; afterwards
`home-manager` is in `PATH`. Then log out and in once so the session variables apply.
Two things still finish themselves on first use: the first zsh start clones znap/zinit
plugins (needs network), and tmux plugins are installed with `prefix + I`.

On NixOS do **not** `make switch` here (the Makefile refuses): the same modules are
applied as part of the system generation by `make switch` in `setup`.

## Targets

| target | what it does |
|---|---|
| `make switch` | build + activate `homeConfigurations.$(hostname)` |
| `make dry` | show what switch would do |
| `make build` | build without activating |
| `make check` | evaluate every host |
| `make update` | update flake inputs |
| `make fmt` | format all nix files |
| `make clean` | remove build outputs, user-level garbage collection |

## Layout

```
flake.nix               homeConfigurations, homeModules (for setup), overlays, packages
lib/mkHome.nix          homeManagerConfiguration wrapper
lib/nixpkgs-config.nix  allowUnfree + insecure exceptions, shared with setup
hosts/                  one file per host: feature flags only
modules/home/           options (flags), base, terminal, nvim, git, dotfiles links, seed,
                        desktop, fonts, apps, development, containers, nvidia
pkgs/                   derivations for what is not in nixpkgs (webots, screenpen, dbc-utility)
home/                   stow-style dotfiles; linked by modules/home/dotfiles.nix
```

## Currently used with

- NixOS (unstable) / Arch / Ubuntu on WSL
- [tmux](https://github.com/tmux/tmux/wiki) + zsh + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](http://lazyvim.org/)
- [Hyprland](https://hyprland.org/) (Lua config, 0.55+) + [DankMaterialShell](https://danklinux.com/) -- installed by `setup`

## Declared, seeded, or left alone

The dotfiles under `home/` stay plain files (`.zshrc` + zinit, `.tmux.conf` + TPM,
`alacritty.toml`, ...); Home Manager only symlinks them. Three tiers, because
DankMaterialShell rewrites its own config at runtime:

| tier | what | where |
|---|---|---|
| **linked** -- symlink into the checkout | `.zshrc`, `.tmux.conf`, `.tmux/plugins/tpm`, `zsh/`, `alacritty/`, `lazygit/config.yml`, `hyprland.lua`, `plugins.lua`, `dms/binds-user.lua`, `dms/windowrules.lua`, `hypr/scripts/*`, wallpapers | `modules/home/dotfiles.nix` |
| **seeded** -- copied once, then yours | `DankMaterialShell/{settings,clsettings,plugin_settings}.json`, `dms/{binds,colors,layout}.lua`, `discord/settings.json` | `modules/home/seed.nix` |
| **left alone** -- machine-specific state | `monitors.json`, `dms/{outputs,cursor}.lua`, `dms/profiles/` | nothing declares these |

`~/.config/hypr` is linked file by file: a *single file* symlink leaves its parent
directory writable, which is what lets DMS keep generating files next to the linked
ones. Seeds are only written when the target is absent, so live DMS state always wins
over the repo copy -- to re-apply an updated repo version, delete the file and switch.

## Workarounds

### `gcr-ssh-agent` spamming processes at 99% CPU

The plain ssh-agent is used everywhere (NixOS `programs.ssh.startAgent` in `setup`,
`services.ssh-agent` here elsewhere), listening on `$XDG_RUNTIME_DIR/ssh-agent`, which is
what `home/.config/zsh/path.zsh` and `hyprland.lua` point `SSH_AUTH_SOCK` at. If a key is
still ignored, its permissions are too open:

```bash
chmod 600 ~/.ssh/<key>
```

### Rolling back

```bash
home-manager generations          # pick one, run its activate script
```

On NixOS pick the previous generation in GRUB, or `sudo nixos-rebuild switch --rollback`.
