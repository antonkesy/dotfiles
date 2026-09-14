#!/bin/zsh

path+=(/bin)

# local user path
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:$PATH"

# gcr-ssh-agent, gnome-keyring's ssh-agent (desktop.nix enables the socket).
# Its socket unit also exports this into the systemd user environment; set
# here too for anything that did not start from there (tmux, ssh logins).
# No socket (WSL) means no agent.
[[ -S "$XDG_RUNTIME_DIR/gcr/ssh" ]] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# pinentry-gnome3 (git.nix) only needs a tty when it falls back to curses,
# without it signing dies with "Inappropriate ioctl for device".
# Must be $TTY, not $(tty): p10k's instant prompt at the top of .zshrc points
# fd 0/1/2 at /dev/null and a temp file for the rest of the file, so down here
# `tty` prints "not a tty" and `[[ -t 0 ]]` is false. zsh's own $TTY still
# names the real terminal.
if [[ -o interactive && -c ${TTY:-} ]]; then
	export GPG_TTY=$TTY
fi
