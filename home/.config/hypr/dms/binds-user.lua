-- Loaded after binds.lua; hl.unbind() first when overriding one of its keys.
---@module 'hl'

local mod = "SUPER"

hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("google-chrome-stable --ozone-platform=wayland"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("wayscriber --active"))

hl.unbind(mod .. " + P")
hl.bind(mod .. " + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/kill-menu.sh"))

-- scratchpads (pyprland)
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("pypr toggle discord"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("pypr toggle mail"))
hl.unbind(mod .. " + SHIFT + P")
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("pypr toggle missioncenter"))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("pypr toggle calendar"))
hl.bind(mod .. " + SHIFT + Y", hl.dsp.exec_cmd("pypr toggle music"))

-- screenshots
hl.bind(mod .. " + S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("dms screenshot full"))

-- system
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind("CTRL + Escape", hl.dsp.exec_cmd("dms ipc call bar toggle index 0"))
