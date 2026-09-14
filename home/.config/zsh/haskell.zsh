#!/bin/zsh

export PATH="$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"
