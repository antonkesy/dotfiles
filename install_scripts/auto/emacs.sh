#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt install -y emacs

git clone https://github.com/syl20bnr/spacemacs "$HOME"/.emacs.d
