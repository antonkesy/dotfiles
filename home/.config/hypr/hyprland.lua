---@module 'hl'
-- Hyprland Configuration
-- https://wiki.hypr.land/Configuring/

-- no theme generation from dms
hl.env("DMS_DISABLE_MATUGEN", 1)

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1.2,
})

-- unscale XWayland

hl.config({
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
    input = {
        kb_layout = "us",
        numlock_by_default = true,
        kb_options = "compose:ralt",
    },
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 5,
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 30,
            render_power = 5,
            offset = "0 5",
            color = "rgba(00000070)",
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        mfact = 0.5,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 1,
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("uwsm finalize")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("awww img ~/.config/wallpapers/XPPeepo_M4x_Day.png")
end)

require("dms.colors")
pcall(require, "dms.outputs") -- gitignored, DMS writes it
require("dms.layout")
pcall(require, "dms.cursor") -- gitignored, DMS writes it
require("dms.binds")
require("dms.binds-user")
require("dms.windowrules")
