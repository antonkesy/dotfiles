#!/bin/bash

sudo apt purge nodejs -y
sudo apt autoremove -y

brew install nvm
mkdir ~/.nvm -p
source /home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh && nvm install node && nvm use node
