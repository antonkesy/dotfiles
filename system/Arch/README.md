# Arch

Packages and the system half for an Arch machine, via ansible: pacman/AUR,
systemd and PAM, including the wayland helpers, fonts and GUI apps that need the
distro's GL stack. Nothing here writes under `~`. Last, the `nix` role installs
nix and runs home-manager from `home/`, which owns everything under `~`
(terminal environment and the hypr/DMS config).

## Fresh install

**Phase 1, on the live ISO.** `archinstall.json` pre-seeds GRUB, locale, timezone,
NetworkManager, zram swap and the packages phase 2 needs, with profile *Minimal*
(no desktop, greeter or gfx driver). Partitioning and the root/user passwords are
left to archinstall's menu on purpose: some machines dual-boot, and no password
hashes in git. The hostname is always `ak`.

```bash
iwctl station wlan0 connect <SSID>          # wifi, if needed
curl -fsSLO https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/archinstall.json
archinstall --config archinstall.json
```

In the menu set *Disk configuration* and *Authentication* (root password, user
`ak` with sudo), then *Install*. Reboot, pull the stick.

**Phase 2, after the first login.**

```bash
nmcli device wifi connect <SSID> --ask        # wifi, if needed
curl -fsSL https://raw.githubusercontent.com/antonkesy/dotfiles/main/system/Arch/bootstrap.sh | bash
```

`bootstrap.sh` installs `ansible`, clones this repo into `~/Projects/dotfiles` and
runs `make arch`.

## Daily use

From this directory (`make arch` also works at the repo root).

| target | what it does |
|---|---|
| `make arch` | apply the playbook: every role |
| `make dry` | `ansible --check --diff` on this machine |
| `make lint` | ansible-lint |
| `make test` | `make dry` inside the Arch container (services, PAM, nix skipped) |
| `make dev` | shell in that container, repo bind-mounted |
| `make clean` | remove `./build` (AUR builds) |

Roles, in order: `base` (base-devel, git, curl, sudo, zsh as login shell, openssh,
Flathub, timezone, locale), `desktop` (Hyprland, uwsm, hyprlock, hypridle, portals,
greetd + tuigreet starting the uwsm session, pipewire, DankMaterialShell
(`dms-shell` + `dms-shell-hyprland`), NetworkManager,
cups/avahi/bluetooth/gvfs/udisks2, mesa + intel-media-driver, steam,
gpu-screen-recorder, ollama, keyring PAM, and the packages behind the GUI user half:
alacritty, wayland helpers, fonts, GUI apps via pacman/AUR), `nvidia` (driver,
container toolkit, cuda, nvtop), `laptop` (fprintd + PAM, power management, powertop,
Dell tools), `containers` (docker daemon + group), and last `nix`: Determinate
installer, then `nix run ~/Projects/dotfiles/home#home-manager -- switch --flake
~/Projects/dotfiles/home#ak -b hm-bak` (what `make home` at the repo root does;
everything under `~`, hypr/DMS config included).

There is one host, `ak`, and no feature flags: every role runs on every machine
(nvidia and laptop included), the only gate is `is_container` for the docker check
run. The home-manager configuration is always `ak`. `~/Projects/dotfiles`
is load-bearing: home-manager links `~/.config` into that checkout, and the `nix`
role refuses to run from anywhere else. AUR builds land in `./build`.

## Manual steps

`manual/hyprpm.sh`: Hyprland plugins via `hyprpm` (cannot run under sudo, needs a
running Hyprland). Fingerprints: `fprintd-enroll`.

## Layout

```
archinstall.json     archinstall answer file (phase 1): download it on the live ISO, archinstall --config
bootstrap.sh         phase 2: pacman prerequisites, clone this repo, make arch
ansible/site.yml     one play, every role
ansible/roles/       base, desktop, nvidia, laptop, containers, nix, aur_build
docker/              Arch image for make test / dev
manual/              what stays interactive
```
