#!/bin/bash
# all small packages without grouping

sudo apt-get install git -y
sudo apt-get install -y \
    ffmpeg \
    flex  \
    pandoc  \
    pdfarranger  \
    thunderbird  \
    gimp  \
    baobab  \
    curl  \
    qt6-base-dev  \
    python3-distutils  \
    latexmk  \
    texstudio  \
    texlive-full  \
    ubuntu-restricted-extras \
    libreoffice

sudo snap install krita postman obs-studio
pip install pre-commit

sudo apt-get install -y exfat-fuse ntfs-3g # disk format support
sudo apt-get -y ibwebkit2gtk-4.0-37 # Cisco AnyConnect

sudo flatpak -y install flathub io.missioncenter.MissionCenter # https://missioncenter.io
sudo flatpak install flathub net.ankiweb.Anki

cargo install exa bat ripgrep fd-find procs btm bottom
