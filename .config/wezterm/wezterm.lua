local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "xterm-256color"

config.color_scheme = "rose-pine-moon"

config.window_background_opacity = 0.7
config.window_decorations = "RESIZE"
config.macos_window_background_blur = 70

config.font_size = 13

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

return config
