-- Loaded after binds.lua; hl.unbind() first when overriding one of its keys.
---@module 'hl'

local mod = "SUPER"

hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("google-chrome-stable --ozone-platform=wayland"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("wayscriber --active"))

hl.unbind(mod .. " + P")
hl.bind(mod .. " + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/kill-menu.sh"))

-- scratchpads
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/discord-scratchpad.sh"))
hl.window_rule({
    name  = "workspace_special_di",
    match = { class = "^(discord)$" },
    workspace = "special:discord silent",
})

hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/mail-scratchpad.sh"))
hl.window_rule({
    name  = "workspace_special_ma",
    match = { class = "org.mozilla.Thunderbird" },
    workspace = "special:mail silent",
})

hl.unbind(mod .. " + SHIFT + P")
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/task-manager-scratchpad.sh"))
hl.window_rule({
    name  = "workspace_special_mi",
    match = { class = "io.missioncenter.MissionCenter" },
    workspace = "special:missioncenter silent",
})

hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/calendar.sh"))
hl.window_rule({
    name  = "workspace_special_ca",
    match = { class = "org.gnome.Calendar" },
    workspace = "special:calendar silent",
})

hl.bind(mod .. " + SHIFT + Y", hl.dsp.exec_cmd("~/.config/hypr/scripts/music.sh"))
hl.window_rule({
    name  = "workspace_special_mu",
    match = { class = "io.bassi.Amberol" },
    workspace = "special:music silent",
})

-- screenshots
hl.bind(mod .. " + S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("dms screenshot full"))

-- system
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind("CTRL + Escape", hl.dsp.exec_cmd("dms ipc call bar toggle index 0"))
