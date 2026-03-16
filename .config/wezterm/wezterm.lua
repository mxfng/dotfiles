local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "xterm-256color"
config.enable_wayland = true

config.color_scheme = "rose-pine-moon"

config.window_background_opacity = 0.80
config.window_decorations = "NONE"
config.macos_window_background_blur = 70
config.window_padding = {
	left = 12,
	right = 12,
	top = 8,
	bottom = 8,
}

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

return config
