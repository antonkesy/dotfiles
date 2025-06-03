# dotfiles

- Ubuntu 24.04.2 LTS
- Nvidia RTX 4070 with Razer Core X Chrome eGPU
- [tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://ohmyz.sh/)
- [LunarVim](https://www.lunarvim.org/)
- [Spacemacs](https://www.spacemacs.org/)

## TL:DR

```
sudo apt-get -y update && sudo apt-get -y install git locales tzdata sudo build-essential && git clone --recursive https://github.com/antonkesy/dotfiles.git && cd dotfiles && make install_base
```

or for full installation:

```
... make install_all_auto
```

## Running on Ubuntu Version

- 24.04 - [![Ubuntu 24.04 Test Status](https://github.com/antonkesy/dotfiles/actions/workflows/docker-test-24-04.yml/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/docker-test-24-04.yml)
- 22.04 - [![Ubuntu 22.04 Test Status](https://github.com/antonkesy/dotfiles/actions/workflows/docker-test-22-04.yml/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/docker-test-22-04.yml)
- 20.04 - [![Ubuntu 20.04 Test Status](https://github.com/antonkesy/dotfiles/actions/workflows/docker-test-20-04.yml/badge.svg)](https://github.com/antonkesy/dotfiles/actions/workflows/docker-test-20-04.yml)

## Demo

`make demo`

### Limitations

- snap not working in docker/demo/CI
