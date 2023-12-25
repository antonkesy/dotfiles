#!/bin/bash
# all small packages without grouping

apt-get install git -y
DEBIAN_FRONTEND=noninteractive apt install -y ffmpeg pandoc pdfarranger curl qt6-base-dev python3-distutils ubuntu-restricted-extras build-essential
apt-get install -y exfat-fuse ntfs-3g # disk format support
apt-get -y ibwebkit2gtk-4.0-37 # Cisco AnyConnect
