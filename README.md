# dotfiles

- Ubuntu 24.04.2 LTS
- Nvidia RTX 4070 with Razer Core X Chrome eGPU
- tmux + zsh
- LunarVim

## TL:DR

```
sudo apt-get -y update && sudo apt-get -y install git locales tzdata sudo build-essential && git clone --recursive https://github.com/antonkesy/dotfiles.git && make install_base
```

## Demo

`make demo`

### Limitations

- snap not working

## Makefile Targets

- `install_base`: install all base packages
- `install_all_auto`: install all packages which are able to be installed automatically
- `install_all`: install all packages
- `install_after_reboot`: install stuff which requires a reboot
- `dev`: mount current directory for changes
- `demo`: play around with all automatically installed packages
- `test`: run all tests
- `clean_test_docker`
- `test_build`
- `test_dev`: copy current directory to docker container
- `test_base`: base install test
- `test_all_auto`: all auto install test
