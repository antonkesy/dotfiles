#!/bin/zsh

path+=(/bin)

# local user path
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:$PATH"

# gpg-agent is the ssh-agent (git.nix), so this is its socket -- the path
# `gpgconf --list-dirs agent-ssh-socket` prints, hardcoded to keep the shell
# startup free of a gpg call.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"

# pinentry-curses (git.nix) prompts on this tty; without it signing dies with
# "Inappropriate ioctl for device". updatestartuptty re-points an agent that a
# previous terminal started.
# Must be $TTY, not $(tty): p10k's instant prompt at the top of .zshrc points
# fd 0/1/2 at /dev/null and a temp file for the rest of the file, so down here
# `tty` prints "not a tty" and `[[ -t 0 ]]` is false. zsh's own $TTY still
# names the real terminal. A wrong value is worse than none -- updatestartuptty
# stores it in the shared agent, so one bad shell breaks signing in lazygit and
# in terminals that were working.
if [[ -o interactive && -c ${TTY:-} ]]; then
	export GPG_TTY=$TTY
	gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
fi
