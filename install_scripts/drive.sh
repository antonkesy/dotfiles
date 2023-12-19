#!/bin/bash

DRIVE_DIR=~/gdrive

mkdir ${DRIVE_DIR} -p

sudo add-apt-repository ppa:alessandro-strada/ppa
sudo apt-get install google-drive-ocamlfuse

# sudo vi /etc/fuse.conf
# uncomment user_allow_other -> allow other users to access the mounted filesystem

google-drive-ocamlfuse ${DRIVE_DIR}
