export EDITOR='nvim'
export VISUAL='nvim'

# create tmux main session
if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
    tmux new-session -A -s main
fi

