#!/bin/bash
set -e

file="/etc/os-release"

if [ ! -f "$file" ]; then
    echo "Cannot determine OS type" >&2
    exit 1
fi

# Load variables from /etc/os-release into the shell
# Safe because the file only contains KEY=VALUE pairs
. "$file"

id="$(printf '%s' "$ID" | tr 'A-Z' 'a-z')"

case "$id" in
    ubuntu|debian)
        sudo apt update -y
        sudo apt install -y python3-yaml
        ;;
    arch|manjaro)
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm python python-yaml
        ;;
    *)
        printf "Unsupported OS: %s\n" "$id" >&2
        exit 1
        ;;
esac
