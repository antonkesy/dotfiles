#!/bin/zsh

# the oh-my-zsh defaults worth keeping, now that OMZ is gone

setopt AUTO_CD # `dir` == `cd dir`
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY HIST_EXPIRE_DUPS_FIRST

bindkey "${terminfo[khome]:-^[[H}" beginning-of-line
bindkey "${terminfo[kend]:-^[[F}" end-of-line
bindkey "${terminfo[kdch1]:-^[[3~}" delete-char

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# shellcheck disable=SC2296
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"
