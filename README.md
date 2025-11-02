# dotfiles

## TL:DR

```
sudo apt-get -y update && sudo apt-get -y install git locales tzdata sudo build-essential && git clone --recursive https://github.com/antonkesy/dotfiles.git && cd dotfiles && make install_base
```

## Step by step

```
sudo apt-get -y update && sudo apt-get -y install git locales tzdata sudo build-essential
```

```
git clone --recursive https://github.com/antonkesy/dotfiles.git
```

```
git clone --recursive git@github.com:antonkesy/dotfiles.git
```

```
cd dotfiles && make install_base
```

or for full installation:

```
... make install_base install_auto
```

## Currently used with ...

- Ubuntu 24.04.3 LTS
- Nvidia RTX 4070
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://ohmyz.sh/)
- [LunarVim](https://www.lunarvim.org/)
- [Spacemacs](https://www.spacemacs.org/)

## Tests

- `make test_ubuntu_24_04`
- `make test_ubuntu_25_04`

## Demo

`make demo`

### Limitations

- snap not working in docker/demo/CI
