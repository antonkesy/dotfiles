-- Optional user keybind overrides.-- Optional per-user keybind overrides (managed by DMS). Loaded after default binds.
---@module 'hl'

local mod = "SUPER"

hl.bind(mod .. " + " .. "T", hl.dsp.exec_cmd("alacritty"))
hl.bind(mod .. " + " .. "E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + " .. "B", hl.dsp.exec_cmd("google-chrome-stable --ozone-platform=wayland"))
hl.bind(mod .. " + " .. "P", hl.dsp.exec_cmd("~/.config/hypr/scripts/kill-menu.sh"))
hl.bind(mod .. " + " .. "space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind(mod .. " + " .. "V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind(mod .. " + " .. "comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
hl.bind(mod .. " + " .. "N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind("SUPER" .. " + " .. "D", hl.dsp.exec_cmd("wayscriber --active"))

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
-- ponytail: still commented out on purpose -- binds.lua already owns
-- SUPER+CTRL+SHIFT+{arrows,HJKL} for "move *window* to monitor". Uncommenting
-- these steals all 8 binds (binds-user loads last) and turns them into
-- "move *workspace* to monitor". Syntax below is correct for 0.56, pick one.
-- for dir, keys in pairs({ l = { "left", "H" }, r = { "right", "L" }, u = { "up", "K" }, d = { "down", "J" } }) do
--     for _, key in ipairs(keys) do
--         hl.bind(mod .. " + CTRL + SHIFT + " .. key, hl.dsp.workspace.move({ monitor = dir }))
--     end
-- end

-- === Screenshots ===
hl.bind(mod .. " + " .. "S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"))
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "S", hl.dsp.exec_cmd("dms screenshot full"))
hl.bind("CTRL" .. " + " .. "Print", hl.dsp.exec_cmd("dms screenshot full"))
hl.bind("ALT" .. " + " .. "Print", hl.dsp.exec_cmd("dms screenshot window"))

-- === System Controls ===
hl.bind(mod .. " + " .. "Escape", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind("CTRL" .. " + " .. "Escape", hl.dsp.exec_cmd("dms ipc call bar toggle index 0"))
