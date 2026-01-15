#!/usr/bin/env bash

# always start discord since it runs in the background after starting once
discord &
hyprctl dispatch movetoworkspacesilent special:discord,class:^discord$
hyprctl dispatch togglespecialworkspace discord
