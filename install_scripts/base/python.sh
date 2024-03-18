#!/bin/bash

VERSION="3.11"

rm /usr/lib/python${VERSION}/EXTERNALLY-MANAGED
apt install -y python3-pip pipx python${VERSION}-full python${VERSION}-dev
pip install pre-commit
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.${VERSION} 1
