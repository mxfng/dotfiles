local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").moon

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

config.term = "xterm-256color"

config.force_reverse_video_cursor = true
config.colors = theme.colors()

config.window_background_opacity = 0.7
config.window_decorations = "RESIZE"
config.macos_window_background_blur = 70

config.font_size = is_darwin() and 13 or 11

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
	{ key = "Enter", mods = "SHIFT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = '"', mods = "SHIFT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "H", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "L", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Right") },
	{ key = "K", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "J", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "H", mods = "SHIFT|CTRL|SUPER", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "L", mods = "SHIFT|CTRL|SUPER", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "K", mods = "SHIFT|CTRL|SUPER", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "J", mods = "SHIFT|CTRL|SUPER", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "D", mods = "SHIFT|CTRL|SUPER", action = act.ShowDebugOverlay },
	{ key = "X", mods = "SHIFT|CTRL|ALT", action = act.ActivateCopyMode },
	{ key = "Z", mods = "SHIFT|CTRL|ALT", action = act.TogglePaneZoomState },
}

return config
