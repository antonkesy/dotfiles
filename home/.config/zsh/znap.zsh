#!/bin/zsh

[[ -r ${HOME}/.repos/znap/znap.zsh ]] || git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ${HOME}/.repos/znap
source ${HOME}/.repos/znap/znap.zsh
