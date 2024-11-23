# benchmark
# zmodload zsh/zprof

ZSH_DISABLE_COMPFIX=true
[[ -r ~/.repos/znap/znap.zsh ]] || git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.repos/znap
source ~/.repos/znap/znap.zsh

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# https://github.com/starship/starship
eval "$(starship init zsh)"

# zinit
source ~/.zinit.zsh

path+=(/bin)

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

# local user path
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
# Haskell
export PATH="$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"

#flatpak
export PATH="/var/lib/flatpak/exports/share:$PATH"
export PATH="$HOME/.local/share/flatpak/exports/share:$PATH"

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

# Rust
source "$HOME/.cargo/env"

# TACO
alias audissh="ssh audi@192.168.1.102"

# Haskell
[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env" # ghcup-env

# tmux
export EDITOR='nvim'
export VISUAL='nvim'

# create tmux main session
if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
    tmux new-session -A -s main
fi

# https://github.com/Schniz/fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# dart
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Load Angular CLI autocompletion.
source <(ng completion script)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# zprof
