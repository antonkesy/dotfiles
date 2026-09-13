# Arch

Packages and the system half for an Arch machine, via ansible: pacman/AUR,
systemd and PAM, including the wayland helpers, fonts and GUI apps that need the
distro's GL stack. Nothing here writes under `~`. Last, the `nix` role installs
nix and runs home-manager from the repo root, which owns everything under `~`
(terminal environment and the hypr/DMS config).

## Fresh install

**Phase 1, on the live ISO.** `archinstall.json` pre-seeds GRUB, locale, timezone,
NetworkManager, zram swap and the packages phase 2 needs, with profile *Minimal*
(no desktop, greeter or gfx driver). Partitioning and the root/user passwords are
left to archinstall's menu on purpose: `akdesk` dual-boots, and no password hashes
in git.

```bash
iwctl station wlan0 connect <SSID>          # wifi, if needed
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/install.sh | bash -s -- akdesk
```

In the menu set *Disk configuration* and *Authentication* (root password, user
`ak` with sudo), then *Install*. Reboot, pull the stick.

**Phase 2, after the first login.**

```bash
nmcli device wifi connect <SSID> --ask        # wifi, if needed
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
```

`bootstrap.sh` installs `ansible`, clones this repo into `~/Projects/dotfiles` and
runs `make arch` for the profile named after the hostname (`HOST=ak` for the
generic one: `curl ... | HOST=ak bash`).

## Daily use

Run from the repo root (the root Makefile forwards here) or from this directory.

| target | what it does |
|---|---|
| `make arch` | apply profile `ansible/hosts/$(hostname).yml` (`HOST=ak` for the generic one) |
| `make ansible-check` | dry run |
| `make ansible-syntax` / `make lint` | playbook syntax check / ansible-lint |
| `make test-arch` | `ansible --check` inside the Arch container (services, PAM, nix skipped) |
| `make dev-arch` | shell in that container, repo bind-mounted |
| `make clean` | remove `./build` (AUR builds) |

Roles, in order: `base` (base-devel, git, curl, sudo, zsh as login shell, openssh,
Flathub, timezone, locale), `desktop` (Hyprland, uwsm, hyprlock, hypridle, portals,
greetd + tuigreet, pipewire, DankMaterialShell from the AUR, NetworkManager,
cups/avahi/bluetooth/gvfs/udisks2, mesa + intel-media-driver, steam,
gpu-screen-recorder, ollama, keyring PAM, and the packages behind the GUI user half:
alacritty, wayland helpers, fonts, GUI apps via pacman/AUR), `nvidia` (driver,
container toolkit, cuda, nvtop), `laptop` (fprintd + PAM, power management, powertop,
Dell tools), `containers` (docker daemon + group), and last `nix`: Determinate
installer, then `nix run ~/Projects/dotfiles#home-manager -- switch --flake
~/Projects/dotfiles#ak -b hm-bak` (what `make switch` at the repo root does;
everything under `~`, hypr/DMS config included).

Feature flags live in `ansible/hosts/<name>.yml`; a profile that does not exist
fails the run. The home-manager configuration is always `ak`. `~/Projects/dotfiles`
is load-bearing: home-manager links `~/.config` into that checkout, and the `nix`
role refuses to run from anywhere else. AUR builds land in `./build`.

## Manual steps

`manual/hyprpm.sh`: Hyprland plugins via `hyprpm` (cannot run under sudo, needs a
running Hyprland). Fingerprints: `fprintd-enroll`.

## Layout

```
archinstall.json     archinstall answer file (phase 1)
install.sh           live-ISO wrapper: sets the hostname, runs archinstall --config
bootstrap.sh         phase 2: pacman prerequisites, clone this repo, make arch
ansible/site.yml     one play, roles gated by the profile's flags
ansible/hosts/       profiles: akdesk, aklap, ak
ansible/roles/       base, desktop, nvidia, laptop, containers, nix, aur_build
docker/              Arch image for make test-arch / dev-arch
manual/              what stays interactive
```
