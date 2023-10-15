#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

HOME_IMG_PATH=${SCRIPT_DIR}/../res/images/windos_fatal.png
LOCK_IMG_PATH=${SCRIPT_DIR}/../res/images/XPPeepo_M4x_Day.png
echo Using home background image: "${HOME_IMG_PATH}"
echo Using lock background image: "${LOCK_IMG_PATH}"

# gsettings get org.gnome.desktop.interface color-schemke
gsettings set org.gnome.desktop.background picture-uri-dark file://"${HOME_IMG_PATH}"
gsettings set org.gnome.desktop.background picture-uri file://"${HOME_IMG_PATH}"

gsettings set com.ubuntu.login-screen background-picture-uri file://"${LOCK_IMG_PATH}"
