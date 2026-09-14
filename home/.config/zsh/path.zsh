#!/bin/zsh

path+=(/bin)

# local user path
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:$PATH"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"

# pinentry-curses (git.nix) prompts on this tty; without it signing dies with
# "Inappropriate ioctl for device". updatestartuptty re-points an agent that a
# previous terminal started.
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
