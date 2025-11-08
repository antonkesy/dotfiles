#!/bin/bash

sudo apt purge nodejs -y
sudo apt autoremove -y

brew install fnm --skip-post-install
fnm install v23.3.0
