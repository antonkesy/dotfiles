#!/bin/bash

# Manual: hyprpm needs sudo but refuses to be called by sudo.

hyprpm update
# Add hypr-dynamic-cursors plugin
yes | hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors

hyprpm reload
