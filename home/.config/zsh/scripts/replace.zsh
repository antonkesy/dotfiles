#!/usr/bin/env bash
# replace <from_word> <to_word>: whole-word, recursive, in place
# text files only; skips .git (and anything git ignores, inside a repo)

if [ $# -ne 2 ]; then
	echo "Usage: $0 <from_word> <to_word>"
	exit 1
fi

from=$(printf '%s' "$1" | sed 's/[][\\.*^$|]/\\&/g')
to=$(printf '%s' "$2" | sed 's/[\\&|]/\\&/g')

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	git grep -lzIw -F -e "$1"
else
	grep -rlZIw -F --exclude-dir=.git -e "$1" .
fi | xargs -0 -r sed -i "s|\b$from\b|$to|g"
