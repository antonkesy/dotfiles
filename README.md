# Dotfiles

Arch Linux dotfiles and system setup using Ansible.

## Fresh Arch Install

- Ensure `sudo` is available for the user
  - `pacman -S --noconfirm --needed sudo` as `root`/`su`

```bash
curl https://github.com/antonkesy/dotfiles/blob/main/arch_install_config.json
# setup all missing parts like partitioning, users, etc.
archinstall --config arch_install_config.json
mkdir -p ~/workspace && cd ~/workspace
git clone --recursive https://github.com/antonkesy/dotfiles.git
./prerequisites.sh
make desktop
```

## Targets

- `make dotfiles` - Links only dotfiles
- `make base` - Minimal setup (for example for WSL)
- `make desktop` - Full desktop setup

## Currently Used With

- Arch Linux
- Nvidia RTX 4070
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://ohmyz.sh/)
- [LunarVim](https://www.lunarvim.org/)
- [Spacemacs](https://www.spacemacs.org/)

## Workarounds

### Gnome Online Accounts on Hyprland

- Just login through Gnome session :)

## Tests

```bash
make test
```
