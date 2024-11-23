#!/bin/bash

sudo apt purge nodejs -y
sudo apt autoremove -y

brew install fnm --skip-shell
fnm install v23.3.0
