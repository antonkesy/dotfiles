#!/usr/bin/env bash
# replace <from_word> <to_word>: whole-word, recursive, in place

if [ $# -ne 2 ]; then
	echo "Usage: $0 <from_word> <to_word>"
	exit 1
fi

find . -type f -exec sed -i "s/\b$1\b/$2/g" {} +
