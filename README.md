# Dotfiles

[![nix](https://github.com/antonkesy/dotfiles/workflows/nix/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/nix.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

NixOS system and Home Manager configuration. (Previously Arch Linux + Ansible —
the setup did break three times, as predicted.)

<img src="./docs/images/preview.png" width="800">

## Try it without installing anything

```bash
make demo
```

Builds the `demo` host into a QEMU image and boots it: Hyprland + DankMaterialShell,
autologin as `ak` / `demo`. Needs `nix` with flakes and KVM — **not** `nixos-rebuild`.
`Ctrl-Alt-G` releases the mouse. `make demo-clean` throws the disk away.

The demo runs the **same module set as `akdesk`** — same apps, same language
toolchains, same nvim config, same shell — minus the two things a VM has no
hardware for: `nvidia.nix` and VirtualBox. First run pulls the full closure
(~10 GiB download, ~30 GiB in the store); after that it starts in seconds.

It renders with llvmpipe, not virgl: `-display gtk,gl=on` needs qemu's GTK to
obtain a host GL context, which fails on many hosts with `GtkGLArea console
lacks DMABUF support`. On a host where virgl does work, opt back in with
`QEMU_OPTS="-display gtk,gl=on" make demo`.

## Hosts

| host | what it is |
|---|---|
| `akdesk` | desktop workstation — NVIDIA RTX 4070, CUDA, VirtualBox, dual-boot with Windows |
| `aklap` | Dell laptop — fingerprint reader, TLP, no NVIDIA |
| `demo` | throwaway QEMU VM for `make demo` |

## Fresh install

- [Download the NixOS ISO](https://nixos.org/download/#nixos-iso)

```bash
# boot the ISO, connect to wifi
sudo systemctl start wpa_supplicant
wpa_cli   # add_network / set_network 0 ssid "..." / set_network 0 psk "..." / enable_network 0

# partition and mount to /mnt yourself (LUKS if you want encryption), then:
sudo nixos-generate-config --root /mnt

mkdir -p /mnt/home/ak/workspace && cd /mnt/home/ak/workspace
git clone --recursive https://github.com/antonkesy/dotfiles.git
cd dotfiles

# the checked-in hardware-configuration.nix files are placeholders
cp /mnt/etc/nixos/hardware-configuration.nix hosts/akdesk/hardware-configuration.nix

sudo nixos-install --flake .#akdesk
reboot
```

Some setups assume the repo lives at `~/workspace/dotfiles` — `modules/home/nvim.nix`
symlinks the nvim config out of the store from there so lazy.nvim can write to it.

## Targets

| target | what it does |
|---|---|
| `make switch` | build + activate for the current hostname |
| `make boot` | activate on next boot |
| `make build` | build without activating |
| `make check` | evaluate and build every host |
| `make update` | update flake inputs |
| `make fmt` | format all nix files |
| `make demo` | boot the desktop config in QEMU |

## Layout

```
flake.nix          inputs and the three nixosConfigurations
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

### What stays mutable on purpose

DankMaterialShell generates `~/.config/hypr/dms/{colors,outputs,layout,cursor,binds}.lua`
and `~/.config/DankMaterialShell/*.json` at runtime. Those are deliberately **not**
declared — `modules/home/hyprland.nix` symlinks single files so the parent directories
stay writable. Declaring them would leave DMS unable to persist anything.

## Workarounds

### Gnome Online Accounts on Hyprland

`gdm` offers both a GNOME and a Hyprland session — log in through GNOME once.

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
