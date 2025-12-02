#!/bin/bash
sudo pacman -S --noconfirm --needed fprintd
sudo systemctl enable fprintd.service
sudo systemctl start fprintd.service
