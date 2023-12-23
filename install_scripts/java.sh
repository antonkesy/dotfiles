#!/bin/bash

sudo apt install -y maven openjdk-21-jdk 
# sudo update-alternatives --install /usr/bin/java java /path/to/java 1
# sudo update-alternatives --config java

# gradle
curl -s "https://get.sdkman.io" | bash
sdk selfupdate force
source "${HOME}/.sdkman/bin/sdkman-init.sh"
sdk install gradle

