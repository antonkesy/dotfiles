#!/usr/bin/env bash

# Usage: replace.sh <from_word> <to_word>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <from_word> <to_word>"
    echo
    echo "Replaces all whole-word occurrences of <from_word> with <to_word>"
    echo "recursively in the current directory."
    echo
    echo "Example:"
    echo "  $0 A B"
    exit 1
fi

FROM_WORD="$1"
TO_WORD="$2"

find . -type f -exec sed -i "s/\\b${FROM_WORD}\\b/${TO_WORD}/g" {} +
