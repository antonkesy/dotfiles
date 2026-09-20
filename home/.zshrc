#!/bin/zsh

# p10k instant prompt; keep at the top
# shellcheck disable=SC2296
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	# shellcheck disable=SC2296
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_DISABLE_COMPFIX=true

export HISTFILE=~/.histfile
export HISTSIZE=100000
export SAVEHIST=100000

source ${HOME}/.config/zsh/untracked.zsh
source ${HOME}/.config/zsh/alias.zsh
source ${HOME}/.config/zsh/zinit.zsh
source ${HOME}/.config/zsh/options.zsh
source ${HOME}/.config/zsh/path.zsh
source ${HOME}/.config/zsh/nix.zsh
[[ -n $WSL_DISTRO_NAME ]] && source ${HOME}/.config/zsh/tmux.zsh
source ${HOME}/.config/zsh/android.zsh
source ${HOME}/.config/zsh/dart.zsh
source ${HOME}/.config/zsh/flutter.zsh
source ${HOME}/.config/zsh/go.zsh
source ${HOME}/.config/zsh/haskell.zsh
source ${HOME}/.config/zsh/nvidia.zsh
source ${HOME}/.config/zsh/atuin.zsh
source ${HOME}/.config/zsh/scripts.zsh
source ${HOME}/.config/zsh/p10k.zsh
source ${HOME}/.config/zsh/opam.zsh
source ${HOME}/.config/zsh/rust.zsh

# sdkman must be last
source ${HOME}/.config/zsh/sdkman.zsh

# nix is the fallback: every nix dir sorts behind the system ones
path=(${path:#(/nix/*|$HOME/.nix-profile/*)} ${(M)path:#(/nix/*|$HOME/.nix-profile/*)})

# byte-compile the sourced files once; later shells load the .zwc
for f in "${HOME}"/.config/zsh/*.zsh; do
	[[ -r $f.zwc && $f.zwc -nt $f ]] || zcompile "$f"
done
