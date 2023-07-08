#!/bin/bash

# wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb
# chmod +x libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb
# sudo dpkg -i libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb
# echo "deb http://security.ubuntu.com/ubuntu impish-security main" | sudo tee /etc/apt/sources.list.d/impish-security.list
# sudo apt-get update
sudo apt-get install libssl1.1

#unityhub
sudo sh -c 'echo "deb https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'
wget -qO - https://hub.unity3d.com/linux/keys/public | sudo apt-key add -
sudo apt update
sudo apt install unityhub blender steam -y
