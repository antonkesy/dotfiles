#!/bin/bash

set -e

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel ansible
