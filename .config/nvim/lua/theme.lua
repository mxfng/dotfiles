-- Reads the current theme for Neovim. The `theme` fish command writes the
-- name to ~/.local/state/theme; ~/.config/theme/themes.tsv maps it to a
-- colorscheme. WezTerm reads the same files.
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

-- Apply the theme if it changed since Neovim last applied it. Track the name
-- here: some schemes set g:colors_name to the family ("rose-pine"), not the
-- variant ("rose-pine-dawn"), so g:colors_name can't tell variants apart.
local applied
function M.apply()
  local cs = M.colorscheme()
  if applied ~= cs then
    -- Load the lazy plugin that provides this colorscheme first. lazy.nvim
    -- does this on its own only at startup, so a live switch to a theme
    -- whose plugin isn't loaded yet would fail with E185.
    pcall(function()
      require("lazy.core.loader").colorscheme(cs)
    end)
    -- Reset to dark first. Light schemes (dawn, latte) set "light" on their
    -- own, but Kanagawa leaves the option alone, so a switch from a light
    -- theme would keep "light" under a dark scheme.
    vim.o.background = "dark"
    vim.cmd.colorscheme(cs)
    applied = cs
  end
end

return M
