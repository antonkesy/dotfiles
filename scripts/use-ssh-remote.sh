#!/usr/bin/env sh
# Rewrite the origin remote of the git repo in $PWD from https to ssh,
# if it points at an antonkesy/* GitHub repo. Used for the main repo and,
# via `git submodule foreach`, every submodule.
set -eu

url=$(git remote get-url origin 2>/dev/null) || exit 0

case "$url" in
https://github.com/antonkesy/*)
	repo=$(echo "$url" | sed -E 's#https://github.com/antonkesy/##; s#\.git$##')
	new="git@github.com:antonkesy/$repo.git"
	git remote set-url origin "$new"
	echo "$(git rev-parse --show-toplevel): origin -> $new"
	;;
git@github.com:antonkesy/*)
	echo "$(git rev-parse --show-toplevel): origin already uses SSH: $url"
	;;
*)
	echo "$(git rev-parse --show-toplevel): origin is not an antonkesy/* GitHub URL: $url"
	;;
esac
