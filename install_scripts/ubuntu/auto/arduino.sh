#!/bin/bash

# https://arduino.github.io/arduino-cli/0.33/installation/
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# https://arduino.github.io/arduino-cli/0.33/installation/#install-via-homebrew-macoslinux
export PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH
brew update
brew install arduino-cli
