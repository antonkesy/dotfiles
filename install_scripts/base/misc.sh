#!/bin/bash
# all small packages without grouping

apt-get install git -y
apt install -y ffmpeg flex pandoc pdfarranger thunderbird libreoffice gimp baobab curl qt6-base-dev anki python3-distutils latexmk texstudio texlive-full ubuntu-restricted-extras
snap install krita postman obs-studio
pip install pre-commit

apt-get install -y exfat-fuse ntfs-3g # disk format support
apt-get -y ibwebkit2gtk-4.0-37 # Cisco AnyConnect
