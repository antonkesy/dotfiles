#!/bin/bash

sudo apt -y update
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
tar xf flutter_linux_3.24.3-stable.tar.xz

sudo mv flutter /opt/flutter

flutter doctor

dart pub global activate melos
