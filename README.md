# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

The terminal environment as a [Home Manager](https://github.com/nix-community/home-manager)
flake: the same zsh, tmux, nvim, git, CLI tools and language toolchains on NixOS, Arch and
Ubuntu on WSL2. Everything that depends on the distro -- the system half (drivers, daemons,
the compositor stack) and the GUI user half (Hyprland + DankMaterialShell config, wayland
helpers, fonts, GUI apps, alacritty itself) -- lives in the sibling repo
[`setup`](https://github.com/antonkesy/setup).

<img src="./docs/images/preview.png" width="800">

## One configuration

There is a single `homeConfigurations.ak`; nothing here differs between machines.
`ak.nixos` is detected, not configured: as a NixOS module (imported by `setup`) the system
owns the session; standalone, this flake enables the generic-Linux shims
(`targets.genericLinux`) instead.

## Fresh machine (Arch, Ubuntu, WSL)

`~/Projects/dotfiles` is load-bearing (`ak.dotfilesDir`): `modules/home/dotfiles.nix`
and `nvim.nix` symlink the files under `home/` straight into the checkout, so lazy.nvim,
tpm and zinit can write next to them and edits apply without a rebuild.

```bash
# 1. nix (multi-user, flakes on) -- or let setup's bootstrap/ansible do all of this
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. clone and switch
mkdir -p ~/Projects && cd ~/Projects
git clone --recursive https://github.com/antonkesy/dotfiles.git
cd dotfiles
make switch
```

The first `make switch` runs home-manager from this flake's pinned input; afterwards
`home-manager` is in `PATH`. Then log out and in once so the session variables apply.
Two things still finish themselves on first use: the first zsh start clones znap/zinit
plugins (needs network), and tmux plugins are installed with `prefix + I`.

WSL needs `[boot] systemd=true` in `/etc/wsl.conf` for the user services (ssh-agent,
gpg-agent); `setup`'s Ubuntu bootstrap writes it.

On NixOS do **not** `make switch` here (the Makefile refuses): the same module is
applied as part of the system generation by `make switch` in `setup`.

## Targets

| target | what it does |
|---|---|
| `make switch` | build + activate `homeConfigurations.ak` |
| `make dry` | show what switch would do |
| `make build` | build without activating |
| `make check` | evaluate the flake |
| `make update` | update flake inputs |
| `make fmt` | format all nix files |
| `make clean` | remove build outputs, user-level garbage collection |

## Layout

```
flake.nix               homeConfigurations.ak, homeModules.default (for setup), packages
lib/mkHome.nix          homeManagerConfiguration wrapper
lib/nixpkgs-config.nix  allowUnfree + insecure exceptions, shared with setup
modules/home/           options (ak.nixos, ak.dotfilesDir), base, terminal, nvim, git,
                        dotfiles links, development, containers
home/                   stow-style dotfiles; linked by modules/home/dotfiles.nix
```

## Currently used with

- NixOS (unstable) / Arch / Ubuntu on WSL
- [tmux](https://github.com/tmux/tmux/wiki) + zsh + [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](http://lazyvim.org/)
- [Hyprland](https://hyprland.org/) + [DankMaterialShell](https://danklinux.com/) -- installed and configured by `setup`

## Linked, not generated

The dotfiles under `home/` stay plain files (`.zshrc` + zinit, `.tmux.conf` + TPM,
`alacritty.toml`, `lazygit/config.yml`, the nvim submodule); Home Manager only symlinks
them into the checkout: `.zshrc`, `.tmux.conf`, `.tmux/plugins/tpm`, `zsh/`, `alacritty/`,
`lazygit/config.yml` (`modules/home/dotfiles.nix`) and `nvim/` (`modules/home/nvim.nix`).
The Hyprland/DMS config with its linked / seeded / left-alone tiers is documented in
`setup/desktop/README.md`.

## Workarounds

### `gcr-ssh-agent` spamming processes at 99% CPU

The plain ssh-agent is used everywhere (`services.ssh-agent` here), listening on
`$XDG_RUNTIME_DIR/ssh-agent`, which is what `home/.config/zsh/path.zsh` and `setup`'s
`hyprland.lua` point `SSH_AUTH_SOCK` at. If a key is still ignored, its permissions are
too open:

```bash
chmod 600 ~/.ssh/<key>
```

### Rolling back

```bash
home-manager generations          # pick one, run its activate script
```

On NixOS pick the previous generation in GRUB, or `sudo nixos-rebuild switch --rollback`.
