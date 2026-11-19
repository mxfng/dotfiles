local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "xterm-256color"

-- The `theme` fish command writes the theme name to the state file.
-- The registry maps the name to a WezTerm scheme.
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

-- WezTerm can watch only a file that exists.
-- Create the state file if it is missing.
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
-- Reload when the state file changes.
wezterm.add_to_config_reload_watch_list(theme_state)

config.window_background_opacity = 0.95

config.window_decorations = "RESIZE"
config.macos_window_background_blur = 70

-- Symbols Nerd Font covers icons newer than the copy built into WezTerm.
config.font = wezterm.font_with_fallback({
  { family = "JetBrains Mono", weight = "Medium" },
  "Symbols Nerd Font Mono",
})
config.font_size = 13

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

return config
