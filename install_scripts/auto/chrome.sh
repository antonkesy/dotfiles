#!/bin/bash

# https://itsfoss.com/install-chrome-ubuntu/
sudo apt-get install -y wget xdg-utils
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo rm ./google-chrome-stable_current_amd64.deb
