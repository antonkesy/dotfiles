# Dotfiles

[![`ansible check`](https://github.com/antonkesy/dotfiles/workflows/Ansible%20Check/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/test-check.yml)
[![Pre-Commit](https://github.com/antonkesy/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/pre-commit.yml)

Arch Linux dotfiles and system setup using Ansible. (Will switch to NixOS once my setup broke 3 times)

## Fresh Arch Install

- Ensure `sudo` is available for the user
  - `pacman -S --noconfirm --needed sudo` as `root`/`su`

```bash
iwctl station <your_wifi_device> connect <your_wifi_ssid>
curl -L https://raw.githubusercontent.com/antonkesy/dotfiles/main/arch_install_config.json -o arch_install_config.json
# setup all missing parts: partitioning & authentication
archinstall --config arch_install_config.json

# Reboot and login into new user
nmcli radio wifi on
nmcli device wifi list
nmcli device wifi connect "<SSID>" --ask

# some setups might assume position of dotfiles in ~/workspace
mkdir -p ~/workspace && cd ~/workspace
sudo pacman -S --noconfirm --needed git # can be skipped if used archinstall config
git clone --recursive https://github.com/antonkesy/dotfiles.git
./prerequisites.sh # can be skipped if used archinstall config
make desktop
# wait some time
reboot
```

## Targets

- `make dotfiles` - Links only dotfiles
- `make base` - Minimal setup (for example for WSL)
- `make desktop` - Full desktop setup
- `make switch-to-ssh` - Switches https git repo to ssh for development

## Currently Used With

- Arch Linux
- Nvidia RTX 4070
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://ohmyz.sh/)
- [LazyVim](http://lazyvim.org/)
- [Hyprland](https://hyprland.org/)
- [Dank Linux](https://https://danklinux.com/)

## Workarounds

### Gnome Online Accounts on Hyprland

- Just login through Gnome session :)

### Broken Yay

If you get an libalpm.so error, its because there is a mismatch of versions of pacman and the AUR helper (yay/paru/...):
```
yay: error while loading shared libraries: libalpm.so.XX: cannot open shared object file: No such file or directory
```

Just remove `yay` or `paru` and reinstall with `make desktop` for example.
```
sudo pacman -Rns yay
sudo rm -f /usr/bin/yay
```


## Tests

```bash
make test
```
