-- Theme for Neovim.
-- The `theme` fish command writes the theme name to ~/.local/state/theme.
-- ~/.config/theme/themes.tsv maps the name to a colorscheme.
local M = {}

local fallback = "rose-pine-moon"

function M.colorscheme()
  local state = vim.fn.expand("~/.local/state/theme")
  local registry = vim.fn.expand("~/.config/theme/themes.tsv")
  local name = vim.fn.filereadable(state) == 1 and vim.trim(vim.fn.readfile(state, "", 1)[1] or "") or ""
  if name == "" or vim.fn.filereadable(registry) == 0 then
    return fallback
  end
  for _, line in ipairs(vim.fn.readfile(registry)) do
    local fields = vim.split(line, "\t")
    if fields[1] == name and fields[3] then
      return fields[3]
    end
  end
  return fallback
end

-- Apply the theme if it changed.
-- Track the applied name here. Some schemes set g:colors_name to the
-- family ("rose-pine"), not the variant ("rose-pine-dawn").
local applied
function M.apply()
  local cs = M.colorscheme()
  if applied ~= cs then
    -- Load the plugin for this colorscheme first.
    -- Without this, a switch to an unloaded plugin fails with E185.
    pcall(function()
      require("lazy.core.loader").colorscheme(cs)
    end)
    -- Set the background to dark first.
    -- Light schemes set "light". Kanagawa does not set the background.
    vim.o.background = "dark"
    vim.cmd.colorscheme(cs)
    applied = cs
  end
end

-- Watch the state file. Apply each change at once, also in an unfocused pane.
-- Restart the watch after each event. A replaced file stops the old watch.
local watcher
function M.watch()
  local path = vim.fn.expand("~/.local/state/theme")
  if watcher then
    watcher:stop()
  end
  watcher = vim.uv.new_fs_event()
  if not watcher then
    return
  end
  watcher:start(path, {}, function()
    vim.schedule(function()
      M.apply()
      M.watch()
    end)
  end)
end

return M
