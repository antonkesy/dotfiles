---@module 'hl'
-- Hyprland Configuration
-- https://wiki.hypr.land/Configuring/

local binds = require("binds")
local plugins = require("plugins")
local outputs = require("dms.outputs")

hl.env("SSH_AUTH_SOCK", "local_var_XDG_RUNTIME_DIR/ssh-agent.socket")

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
})

hl.config({
    input = {
        kb_layout = "us",
        numlock_by_default = true,
        kb_options = "compose:ralt",
    },
})

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,
        -- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        -- col.inactive_border = rgba(0,0,0,0) # TODO: inactive border is transparent, even tho it shouldn't
        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,
        -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false,
        layout = "dwindle",
        col = {
            active_border = "rgb(8aadf4)",
        },
    },
})

hl.config({
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
})

hl.config({
    animations = {
        enabled = true,
    },
})

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        mfact = 0.5,
    },
})


hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 1,
    },
})


hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("dms run")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("awww img ~/.config/wallpapers/XPPeepo_M4x_Day.png")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
end)
