# ALIAS
alias m="make"
alias htop=btop
alias g="lazygit"
# alias cat="bat"
alias l="exa -lah"
alias la="exa -lah"
alias exa="exa -lah"
# alias du="dust"
# alias find="fdfind"
# alias ps="procs -t"
alias lvim="${HOME}/.local/bin/lvim"
alias vim="lvim"
alias neovim="lvim"
alias nvim="lvim"
alias n="nvim"
# alias n.="nvim ."
alias python=python3
alias py=python
alias py3=python3

# use trash-cli instead of rm
compdef rm=trash-put
alias rm="trash-put"
# force rm zsh completion
zstyle ':completion:*:*:rm:*' file-patterns '*'
zstyle ':completion:*' rehash true
autoload -Uz compinit && compinit -C
