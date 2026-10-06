#!/bin/zsh

# WSL has no login password to unlock anything: ask for the git signing key's
# passphrase once per gpg-agent lifetime, at the first prompt (after p10k's instant
# prompt, which must not see input), then preset it -- preset entries never expire
_gpg_unlock() {
	add-zsh-hook -d precmd _gpg_unlock
	local key grip pass
	key=$(git config --get user.signingkey) || return
	# keygrip of the first signing-capable (sub)key
	grip=$(gpg --batch --with-colons --with-keygrip -K "$key" 2>/dev/null |
		awk -F: '$1 ~ /^(sec|ssb)$/ { s = ($12 ~ /s/) } $1 == "grp" && s { print $10; exit }')
	[[ -n $grip ]] || return
	# KEYINFO field 7 is 1 once the passphrase is cached
	[[ $(gpg-connect-agent "KEYINFO $grip" /bye 2>/dev/null | awk '$2 == "KEYINFO" { print $7 }') == 1 ]] && return
	local tries
	for tries in 1 2 3; do
		read -rs "pass?gpg passphrase for $key: " || break
		print
		[[ -n $pass ]] || break
		if print -rn -- "$pass" | gpg --batch --pinentry-mode loopback --passphrase-fd 0 \
			-u "$key" -o /dev/null --sign /dev/null 2>/dev/null; then
			print -rn -- "$pass" | "$(gpgconf --list-dirs libexecdir)"/gpg-preset-passphrase --preset "$grip"
			break
		fi
		print -u2 "wrong passphrase"
	done
	unset pass
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _gpg_unlock
