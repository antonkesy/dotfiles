#!/bin/bash

# https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#supported-distributions
# Get Ubuntu version
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)

# Download Microsoft signing key and repository
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# Install Microsoft signing key and repository
sudo dpkg -i packages-microsoft-prod.deb

# Clean up
rm packages-microsoft-prod.deb

# Update packages
sudo apt update


# sudo apt install dotnet-sdk-6.0 dotnet-runtime-6.0 dotnet-sdk-7.0 dotnet-runtime-7.0 dotnet6 dotnet7 aspnetcore-runtime-6.0 aspnetcore-runtime-7.0 -y

# https://stackoverflow.com/questions/73312785/dotnet-sdk-is-installed-but-not-recognized-linux-ubuntu-popos-22-04
# clean install
sudo snap remove dotnet-sdk
sudo apt remove 'dotnet*'
sudo apt remove 'aspnetcore*'
sudo apt remove 'netstandard*'
sudo rm /etc/apt/sources.list.d/microsoft-prod.list
sudo rm /etc/apt/sources.list.d/microsoft-prod.list.save
sudo apt update
sudo apt install dotnet6 dotnet7 -y
