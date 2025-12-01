# dotfiles

TODO: why not ansible? Because!

## TL:DR

### Arch

For guided Arch install before applying dotfiles use:

```bash
archinstall --config https://github.com/antonkesy/dotfiles/tree/main/distros/arch/user_configuration.json
```

## Currently used with ...

- Arch
- Nvidia RTX 4070
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://ohmyz.sh/)
- [LunarVim](https://www.lunarvim.org/)
- [Spacemacs](https://www.spacemacs.org/)

## Packages

- TODO: install packages depending on the OS (Ubuntu, Arch)
- TODO: run specific package install with `python3 ./packages/package.py \[NAME\]+
- TODO: test with `make test_packages`
- TODO: test specific package with `pytest packages/test.py -vvv -k "NAME"`

## Tests

- `make test_ubuntu_24_04`
- `make test_ubuntu_25_04`

## Workarounds

### Gnome Online Accounts on Hyprland

- Just login through Gnome session :)
