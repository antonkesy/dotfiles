#!/bin/bash

# Manual install since hyprpm requires sudo, but does not allow to be called by sudo ...

hyprpm update
# Add hypr-dynamic-cursors plugin
yes | hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors
# Offical plugins
yes | hyprpm add https://github.com/hyprwm/hyprland-plugins
# HyprExpo2
yes | hyprpm add https://github.com/antonkesy/hyprexpo2
hyprpm enable hyprexpo2

hyprpm reload
