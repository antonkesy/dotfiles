# START_BENCHMARK_STARTUP
# zmodload zsh/zprof
#
# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Antigen
source ~/workspace/git/antigen/antigen.zsh
antigen init ~/.antigenrc

path+=(/bin)

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install

# local user path
export JAVA_HOME="/usr/lib/jvm/java-18-openjdk-amd64"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
# Haskell
export PATH="$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
# NetCoreDebugger
export PATH="$HOME/workspace/git/netcoredbg/build/src:$PATH"


# THEME (antigen broken)
eval "$(starship init zsh)"


# ALIAS
alias g="lazygit"
#alias cat="bat"
alias ls="exa"
alias du="dust"
alias find="fdfind"
# alias ps="procs -t"
alias ssh_hpc="ssh kesy@hpcvl-login.emi.hs-offenburg.de"
alias lvim="/home/ak/.local/bin/lvim"
alias vim="lvim"
alias neovim="lvim"
alias nvim="lvim"
alias python=python3
alias py=python
alias py3=python3

# Rust
. "$HOME/.cargo/env"

# TACO
alias audissh="ssh audi@192.168.1.102"
export VISION_WEIGHT_PATH="/home/ak/workspace/taco/data/weights/best.pt"
alias .ros="
source /opt/ros/humble/setup.zsh
source /home/ak/workspace/taco/install/setup.zsh
"

# ROS2Humble
ROS_VERSION=2
ROS_PYTHON_VERSION=3
ROS_DISTRO=humble

# Webots
export WEBOTS_HOME=/usr/local/webots
export LD_LIBRARY_PATH=$WEBOTS_HOME/lib/controller:$LD_LIBRARY_PATH

# Haskell
[ -f "/home/ak/.ghcup/env" ] && source "/home/ak/.ghcup/env" # ghcup-env

# END_BENCHMARK_STARTUP
# zprof


