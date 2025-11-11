return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "auto",
        dark_variant = "moon",
      })

      vim.cmd("colorscheme rose-pine")
    end,
  },
}
