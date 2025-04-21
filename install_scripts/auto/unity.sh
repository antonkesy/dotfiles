#!/bin/bash

sudo apt-get install libssl1.1

#unityhub
sh -c 'echo "deb https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'
wget -qO - https://hub.unity3d.com/linux/keys/public | sudo apt-key add -
sudo apt update -y
sudo apt install unityhub blender -y
