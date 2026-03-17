local wezterm = require("wezterm")
local config = wezterm.config_builder()
local is_mac = wezterm.target_triple:find("darwin") ~= nil

config.term = "xterm-256color"
config.color_scheme = "rose-pine-moon"

if is_mac then
	config.window_background_opacity = 0.7
	config.window_decorations = "RESIZE"
	config.macos_window_background_blur = 70
else
	config.enable_wayland = true
	config.window_background_opacity = 0.80
	config.window_decorations = "NONE"
	config.window_padding = {
		left = 12,
		right = 12,
		top = 8,
		bottom = 8,
	}
end

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

return config
