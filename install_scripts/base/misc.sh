#!/bin/bash
# all small packages without grouping

sudo apt-get install git -y
DEBIAN_FRONTEND=noninteractive sudo apt install -y ffmpeg pandoc pdfarranger curl qt6-base-dev ubuntu-restricted-extras build-essential
sudo apt-get install -y exfat-fuse ntfs-3g # disk format support
sudo apt-get -y ibwebkit2gtk-4.0-37 # Cisco AnyConnect
