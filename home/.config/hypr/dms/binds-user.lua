-- User keybind overrides; loaded after binds.lua.
-- Hyprland keeps every hl.bind() for a key, it does not replace, so a key
-- binds.lua already owns needs hl.unbind() first or both fire.
-- Nothing here may duplicate a binds.lua default: DMS regenerates that file
-- on version upgrades and this one must not depend on its contents.
---@module 'hl'

local mod = "SUPER"

hl.bind(mod .. " + " .. "E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + " .. "B", hl.dsp.exec_cmd("google-chrome-stable --ozone-platform=wayland"))
hl.bind("SUPER" .. " + " .. "D", hl.dsp.exec_cmd("wayscriber --active"))

-- binds.lua: outputs cycleProfile
hl.unbind(mod .. " + " .. "P")
hl.bind(mod .. " + " .. "P", hl.dsp.exec_cmd("~/.config/hypr/scripts/kill-menu.sh"))

-- Scratchpad discord
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "D", hl.dsp.exec_cmd("~/.config/hypr/scripts/discord-scratchpad.sh"))
hl.window_rule({
    name  = "workspace_special_di",
    match = {
        class = "^(discord)$",
    },
    workspace = "special:discord silent",
})

-- Scratchpad Thunderbird
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "M", hl.dsp.exec_cmd("~/.config/hypr/scripts/mail-scratchpad.sh"))
hl.window_rule({
    name  = "workspace_special_ma",
    match = {
        class = "org.mozilla.Thunderbird",
    },
    workspace = "special:mail silent",
})

-- Task Manager

-- binds.lua: dpms toggle
hl.unbind(mod .. " + " .. "SHIFT" .. " + " .. "P")
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "P", hl.dsp.exec_cmd("~/.config/hypr/scripts/task-manager-scratchpad.sh"))
hl.window_rule({
    name  = "workspace_special_mi",
    match = {
        class = "io.missioncenter.MissionCenter",
    },
    workspace = "special:missioncenter silent",
})

-- Calendar

hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "C", hl.dsp.exec_cmd("~/.config/hypr/scripts/calendar.sh"))

hl.window_rule({
    name  = "workspace_special_ca",
    match = {
        class = "org.gnome.Calendar",
    },
    workspace = "special:calendar silent",
})

-- Music -> Amberol

hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "Y", hl.dsp.exec_cmd("~/.config/hypr/scripts/music.sh"))
hl.window_rule({
    name  = "workspace_special_mu",
    match = {
        class = "io.bassi.Amberol",
    },
    workspace = "special:music silent",
})

-- === Move compelete workspace to Monitor ===
-- Off on purpose: binds.lua already owns these 8 keys for "move window to
-- monitor"; enabling this steals them.
-- for dir, keys in pairs({ l = { "left", "H" }, r = { "right", "L" }, u = { "up", "K" }, d = { "down", "J" } }) do
--     for _, key in ipairs(keys) do
--         hl.bind(mod .. " + CTRL + SHIFT + " .. key, hl.dsp.workspace.move({ monitor = dir }))
--     end
-- end

-- === Screenshots ===
-- binds.lua already owns Print / CTRL+Print / ALT+Print; these are the SUPER aliases
hl.bind(mod .. " + " .. "S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "S", hl.dsp.exec_cmd("dms screenshot full"))

-- === System Controls ===
hl.bind(mod .. " + " .. "Escape", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind("CTRL" .. " + " .. "Escape", hl.dsp.exec_cmd("dms ipc call bar toggle index 0"))
