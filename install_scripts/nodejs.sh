#!/bin/bash

wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh &&
bash install.sh &&
source ~/.zshrc &&
nvm install node
