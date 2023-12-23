#!/bin/bash

# nomachine
wget https://download.nomachine.com/download/8.6/Linux/nomachine_8.6.1_3_amd64.deb
sudo apt install ./nomachine*
rm ./nomachine*

# webots 
# https://cyberbotics.com/doc/guide/installation-procedure#installing-the-debian-package-with-the-advanced-packaging-tool-apt
wget -qO- https://cyberbotics.com/Cyberbotics.asc | sudo apt-key add -
sudo apt-add-repository 'deb https://cyberbotics.com/debian/ binary-amd64/'
sudo apt-get update
sudo apt-get install webots -y
