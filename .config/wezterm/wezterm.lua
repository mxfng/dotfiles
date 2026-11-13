local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "xterm-256color"

-- The `theme` fish command writes the theme name to a state file; the
-- registry maps it to a WezTerm scheme. Watching the state file makes
-- WezTerm reload as soon as the theme changes.
local theme_state = wezterm.home_dir .. "/.local/state/theme"
local theme_registry = wezterm.home_dir .. "/.config/theme/themes.tsv"

local function read_theme()
  local name = "rose-pine-moon"
  local f = io.open(theme_state, "r")
  if f then
    name = (f:read("*l") or name):gsub("%s+$", "")
    f:close()
  end
  local r = io.open(theme_registry, "r")
  if r then
    for line in r:lines() do
      local n, scheme = line:match("^([^#\t][^\t]*)\t([^\t]+)\t")
      if n == name then
        r:close()
        return scheme
      end
    end
    r:close()
  end
  return "rose-pine-moon"
end

-- WezTerm can only watch a file that exists. If the state file is missing
-- when the config loads, the watch silently never starts and `theme` has no
-- effect until a manual reload, so create it with the default first.
local exists = io.open(theme_state, "r")
if exists then
  exists:close()
else
  local f = io.open(theme_state, "w")
  if f then
    f:write("rose-pine-moon\n")
    f:close()
  end
end

config.color_scheme = read_theme()
wezterm.add_to_config_reload_watch_list(theme_state)

config.window_background_opacity = 0.88

config.window_decorations = "RESIZE"
config.macos_window_background_blur = 70

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

return config
