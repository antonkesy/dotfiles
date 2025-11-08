#!/bin/bash

wget https://github.com/alexVinarskis/dell-powermanager/releases/download/0.10.0/dell-powermanager_0.10.0+20240225-201753_amd64.deb
sudo apt install ./dell-powermanager_0.10.0+20240225-201753_amd64.deb -y
sudo rm dell-powermanager_0.10.0+20240225-201753_amd64.deb
