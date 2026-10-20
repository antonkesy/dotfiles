#!/bin/zsh

# create tmux main session
if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
	tmux new-session -A -s main
fi
