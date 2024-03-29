#!/bin/bash

DRIVE_DIR=~/gdrive

mkdir ${DRIVE_DIR} -p

add-apt-repository ppa:alessandro-strada/ppa
apt-get install google-drive-ocamlfuse

# uncomment user_allow_other -> allow other users to access the mounted filesystem
sed -i '/^# *user_allow_other/s/^# //' /etc/fuse.conf

google-drive-ocamlfuse ${DRIVE_DIR}
(crontab -l 2>/dev/null; echo "@reboot sleep 30 && /usr/bin/google-drive-ocamlfuse ${DRIVE_DIR}") | crontab -
