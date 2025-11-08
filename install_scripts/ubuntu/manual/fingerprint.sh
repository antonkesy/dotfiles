#!/bin/bash

# use fingerprint for sudo
sudo apt-get -y install fprintd libfprint-2-2 libpam-fprintd
sudo pam-auth-update
