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
    qtbase5-dev \
    qt6-base-dev  \
    latexmk  \
    texstudio  \
    texlive-full  \
    ubuntu-restricted-extras \
    libreoffice \
    obs-studio

sudo snap install krita postman amberol vlc gimp
pip install pre-commit screenpen

 # disk format support
sudo apt-get install -y exfat-fuse ntfs-3g

 # Cisco AnyConnect
sudo add-apt-repository deb http://gb.archive.ubuntu.com/ubuntu jammy main -y
sudo apt update -y
sudo apt install -y libwebkit2gtk-4.0-dev

# https://missioncenter.io
sudo flatpak -y install flathub io.missioncenter.MissionCenter
sudo flatpak install flathub net.ankiweb.Anki

cargo install exa bat ripgrep fd-find procs bottom

# https://github.com/flameshot-org/flameshot
sudo apt install -y flameshot
