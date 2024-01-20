#!/bin/bash

# use fingerprint for sudo
apt-get install fprintd libfprint-2-2 libpam-fprintd
pam-auth-update
