# Install Zinit if not already installed
if ! [ -f ~/.zinit/bin/zinit.zsh ]; then
  mkdir -p ~/.zinit && git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# Source Zinit
source ~/.zinit/bin/zinit.zsh

# Load oh-my-zsh framework
zinit light ohmyzsh/ohmyzsh

# even lazier loading
zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    thetic/extract

zinit light jeffreytse/zsh-vi-mode # Breaks auto-complete in insert mode; keep an eye on this

autoload -Uz promptinit; promptinit
