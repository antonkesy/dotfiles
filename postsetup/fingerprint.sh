#!/bin/bash
sudo pacman -S --noconfirm --needed fprintd libfprint
sudo systemctl enable fprintd.service
sudo systemctl start fprintd.service
sudo pam-auth-update --enable fprintd # enable fingerprint authentication
fprintd-enroll                        # enroll fingerprint for the current user
