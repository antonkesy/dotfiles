#!/bin/zsh

path+=(/bin)

# local user path
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:$PATH"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
