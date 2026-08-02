#!/usr/bin/env bash

# always start discord since it runs in the background after starting once
discord &
hyprctl dispatch 'hl.dsp.workspace.toggle_special("discord")'
