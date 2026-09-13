# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

_Trying to achieve the best reproducible setup for my personal and professional use_

The terminal environment as a [Home Manager](https://github.com/nix-community/home-manager)
flake: the same `zsh`, `tmux`, `nvim`, `git`, CLI tools and language toolchains `Arch` and
`Ubuntu(WSL2)`.

Everything system level package (drivers, daemons,
the compositor stack, GUI) is installed separately from [`setup`](https://github.com/antonkesy/setup).

<img src="./docs/images/preview.png" width="800">

## TL;DR

```
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

mkdir -p ~/Projects && cd ~/Projects
git clone --recursive https://github.com/antonkesy/dotfiles.git
cd dotfiles
make switch
```

### Manual Steps

tmux plugins install themselves on the first tmux start (needs network); `prefix + I`
is only needed after adding a plugin to `.tmux.conf`.

#### WSL

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
