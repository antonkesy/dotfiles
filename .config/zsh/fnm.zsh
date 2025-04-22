# fnm
FNM_PATH="/home/${USER}/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/${USER}/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# https://github.com/Schniz/fnm
eval "$(fnm env --use-on-cd --shell zsh)"
