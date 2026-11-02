-- Hyprland 0.57+ config (Lua). Minimal: ergonomics only, no decoration.
-- https://wiki.hypr.land/configuring/

local terminal = "wezterm"
local menu = "rofi -show drun"
local mod = "SUPER"

-- Monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.25 })

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("hypridle")
end)

-- Environment
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

hl.config({
    dwindle = { preserve_split = true },
    master = { new_status = "master" },
    misc = { force_default_wallpaper = 0, disable_hyprland_logo = true },
    cursor = { no_hardware_cursors = true },
    input = {
        touchpad = {
            natural_scroll = true,
            clickfinger_behavior = true,
            scroll_factor = 0.125,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- App-level
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))

-- Focus, move, resize (vim keys on SUPER + ALT)
local dirs = { H = "left", J = "down", K = "up", L = "right" }
for key, dir in pairs(dirs) do
    hl.bind(mod .. " + ALT + " .. key, hl.dsp.focus({ direction = dir }))
    hl.bind(mod .. " + ALT + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end
hl.bind(mod .. " + ALT + minus", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT + equal", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

-- Layout
hl.bind(mod .. " + ALT + Z", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + ALT + T", hl.dsp.window.float({ action = "toggle" }))

-- Workspaces
for i = 1, 8 do
    hl.bind(mod .. " + ALT + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + ALT + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + ALT + left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mod .. " + ALT + right", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mod .. " + ALT + TAB", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mod .. " + ALT + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mod .. " + ALT + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mod .. " + ALT + SHIFT + TAB", hl.dsp.workspace.move({ monitor = "+1" }))

-- Scratchpad
hl.bind(mod .. " + ALT + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + ALT + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
local lockedRepeat = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), lockedRepeat)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), lockedRepeat)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), lockedRepeat)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), lockedRepeat)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), lockedRepeat)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), lockedRepeat)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Window rules
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
