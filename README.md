# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

NixOS system and Home Manager configuration.

<img src="./docs/images/preview.png" width="800">

## Hosts

| host | what it is |
|---|---|
| `akdesk` | desktop workstation — NVIDIA RTX 4070, CUDA, VirtualBox, dual-boot with Windows |
| `aklap` | Dell laptop — same config as `akdesk`, plus fingerprint reader and power management, minus VirtualBox |

## Fresh install

### 1. Install NixOS

[Download the ISO](https://nixos.org/download/#nixos-iso) and follow the
[installation manual](https://nixos.org/manual/nixos/stable/#sec-installation) —
partitioning, user `ak` with a password, **no desktop environment**. This repo
takes over from there. Secure Boot **off**: the NVIDIA kernel modules are
unsigned and will not load otherwise.

### 2. Reboot and take over

`~/Projects/dotfiles` is load-bearing — `modules/home/nvim.nix` symlinks
`~/.config/nvim` into it so lazy.nvim can write lock files into a real checkout.

```bash
mkdir -p ~/Projects && cd ~/Projects
git clone --recursive https://github.com/antonkesy/dotfiles.git
cd dotfiles
nmtui                                # wifi, via NetworkManager
```

### 3. Use the machine's real hardware config, then switch

The tracked `hosts/$HOST/hardware-configuration.nix` is only a stub so the flake
evaluates anywhere; the installer wrote the real one. Copy it over **before** the
first switch, or the new generation boots with the stub's filesystems:

```bash
HOST=akdesk   # or aklap
cp /etc/nixos/hardware-configuration.nix hosts/$HOST/hardware-configuration.nix
git add hosts/$HOST/hardware-configuration.nix   # flakes ignore untracked files
make switch                                      # HOST defaults to `hostname`
```

If `make switch` rebuilds cleanly, that is the whole workflow from here on. Swap
the remotes to SSH once your keys are in place.

## Targets

| target | what it does |
|---|---|
| `make switch` | build + activate for the current hostname |
| `make boot` | activate on next boot |
| `make build` | build without activating |
| `make check` | evaluate and build every host |
| `make update` | update flake inputs |
| `make fmt` | format all nix files |
| `make desktop` | regenerate this machine's `hardware-configuration.nix`, hide it from git (`skip-worktree`), then switch |

## Layout

```
flake.nix          inputs and the two nixosConfigurations
lib/mkHost.nix     nixosSystem wrapper, wires in Home Manager
hosts/             per-machine config + hardware-configuration.nix
modules/nixos/     system modules (base, desktop, apps, development, ...)
modules/home/      Home Manager modules (zsh, tmux, terminal, hyprland, nvim, git)
pkgs/              derivations for what is not in nixpkgs
home/              raw dotfile content consumed by modules/home/
```

## Currently used with

- NixOS (unstable)
- NVIDIA RTX 4070
- [tmux](https://github.com/tmux/tmux/wiki) + zsh + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](http://lazyvim.org/)
- [Hyprland](https://hyprland.org/) (Lua config, 0.55+)
- [DankMaterialShell](https://danklinux.com/)

## What changed from the Ansible setup

Things that used to be imperative and are now declarative, or simply gone:

- `yay`/`paru`/`makepkg` and the hand-rolled `aur_build` role — everything is a nixpkgs
  attribute or a derivation in `pkgs/`
- `ghcup`, `opam init`, SDKMAN, `pipx`, `cargo install`, `go install ...@latest`,
  `luarocks install` as root — all pinned toolchains now
- neovim and flutter built from source into `/usr/local` and `setup/build/`
- `stow --adopt`, which moved files *into* the repo — Home Manager symlinks out of it
- znap and zinit, which `git clone`d themselves on every shell start —
  `programs.zsh.plugins`
- TPM and `~/.tmux/plugins` — `programs.tmux.plugins` writes store paths directly
- a hand-written `/etc/systemd/system/ollama.service` (that never created the `ollama`
  user), `nvidia-ctk runtime configure`, and `lineinfile` edits to `/etc/pam.d/*` —
  all first-class NixOS options now
- `hyprpm`, which compiles plugins against the running Hyprland and cannot work on
  NixOS — use `programs.hyprland.plugins`

### Declared, seeded, or left alone

Three tiers, because DankMaterialShell rewrites its own config at runtime:

| tier | what | where |
|---|---|---|
| **declared** — read-only store symlink | `hyprland.lua`, `plugins.lua`, `dms/binds-user.lua`, `dms/windowrules.lua`, `hypr/scripts/*`, zsh fragments, wallpapers | `modules/home/hyprland.nix`, `zsh.nix` |
| **seeded** — copied once, then yours | `DankMaterialShell/{settings,clsettings,plugin_settings}.json`, `dms/{binds,colors,layout}.lua`, `discord/settings.json` | `modules/home/seed.nix` |
| **left alone** — machine-specific state | `monitors.json`, `dms/{outputs,cursor}.lua`, `dms/profiles/` | nothing declares these |

Symlinking a *single file* leaves its parent directory writable, which is what lets
DMS keep generating files next to the declared ones. Seeds are only written when the
target is absent, so live DMS state always wins over the repo copy — to re-apply an
updated repo version, delete the file and `make switch`.

That tiering is why the repo's own `.gitignore` files matter: they already mark
machine-specific state, and `seed.nix` seeds exactly the tracked set.

## Workarounds

### `gcr-ssh-agent` spamming processes at 99% CPU

Already handled: `hosts/common.nix` disables `services.gnome.gcr-ssh-agent` and uses
`programs.ssh.startAgent`, which is what `home/.config/zsh/path.zsh` points
`SSH_AUTH_SOCK` at. If a key is still ignored, its permissions are too open:

```bash
chmod 600 ~/.ssh/<key>
```

### Rolling back a bad generation

Pick the previous generation in the GRUB menu, or:

```bash
sudo nixos-rebuild switch --rollback
```
