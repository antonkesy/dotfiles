#!/bin/zsh

path+=(/bin)

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:$PATH"

# gcr-ssh-agent (desktop.nix); no socket on WSL
[[ -S "$XDG_RUNTIME_DIR/gcr/ssh" ]] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# curses fallback of pinentry-gnome3 needs a tty; $TTY survives p10k's instant prompt, $(tty) does not
if [[ -o interactive && -c ${TTY:-} ]]; then
	export GPG_TTY=$TTY
fi
