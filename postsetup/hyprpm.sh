#!/bin/bash

# Manual install since hyprpm requires sudo, but does not allow to be called by sudo ...

hyprpm update
# Add hypr-dynamic-cursors plugin
yes | hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors
yes | hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo
