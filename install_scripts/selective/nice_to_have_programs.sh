#!/bin/bash
# all small packages without grouping

apt-get install git -y
apt-get install -y \
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

snap install krita postman obs-studio
pip install pre-commit

apt-get install -y exfat-fuse ntfs-3g # disk format support
apt-get -y ibwebkit2gtk-4.0-37 # Cisco AnyConnect

flatpak -y install flathub io.missioncenter.MissionCenter # https://missioncenter.io
flatpak install flathub net.ankiweb.Anki
