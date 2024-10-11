[[ -r ~/.repos/znap/znap.zsh ]] || git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.repos/znap
source ~/.repos/znap/znap.zsh

znap prompt sindresorhus/pure
znap source marlonrichert/zsh-autocomplete
znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'

znap install ael-code/zsh-colored-man-pages
znap install momo-lab/zsh-abbrev-alias

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Antigen
source ~/.repos/antigen/antigen.zsh
antigen init ~/.antigenrc

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
alias rm="trash-put"

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

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# dart
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Load Angular CLI autocompletion.
source <(ng completion script)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
