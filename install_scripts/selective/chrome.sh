#!/bin/bash

# https://itsfoss.com/install-chrome-ubuntu/
apt-get install -y wget
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
rm ./google-chrome-stable_current_amd64.deb

