#!/bin/bash
# run as user inside Hyprland

hyprpm update
yes | hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors
hyprpm reload
