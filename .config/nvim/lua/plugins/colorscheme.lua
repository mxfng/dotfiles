-- The colorscheme follows the `theme` fish command (see lua/theme.lua).
-- Catppuccin ships with LazyVim; Rosé Pine and Kanagawa are added here.
-- All load lazily: lazy.nvim loads the plugin when its colorscheme is set.
return {
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("theme").apply()
      end,
    },
  },
}
