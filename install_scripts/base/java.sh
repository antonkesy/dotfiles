#!/bin/bash

apt install -y maven openjdk-21-jdk 

# gradle
curl -s "https://get.sdkman.io" | bash
source "${HOME}/.sdkman/bin/sdkman-init.sh"
# not working correctly
sdk selfupdate force
sdk install gradle

