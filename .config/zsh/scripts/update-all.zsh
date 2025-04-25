#!/bin/zsh

echo "Starting system-wide package update..."

# Update function
update_manager() {
    local name=$1
    local cmd=$2

    if command -v ${name%% *} >/dev/null 2>&1; then
        echo "\nUpdating ${name} packages..."
        eval "$cmd" || echo "${name} update failed. Skipping..."
    else
        echo "${name} not found. Skipping..."
    fi
}

# Ordered list of managers
ordered_managers=("apt" "brew" "snap" "flatpak" "cargo" "pipx" "rust" "stack" "omz")

# Commands map
typeset -A managers
managers=(
    "apt"     "sudo apt update && sudo apt upgrade -y"
    "brew"    "brew update && brew upgrade"
    "snap"    "sudo snap refresh"
    "flatpak" "sudo flatpak update -y"
    "cargo"   "cargo install-update -a"
    "pipx"    "pipx upgrade-all"
    "rust"    "rustup update && rustup upgrade"
    "stack"   "stack update && stack upgrade"
    "omz"     "omz update"
)

# Run updates in order
for manager in "${ordered_managers[@]}"
do
    update_manager "$manager" "${managers[$manager]}"
done

echo "\nAll available updates completed (errors may have been skipped)."
