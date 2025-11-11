return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "rose-pine",
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })

      if vim.fn.argc(-1) == 0 then
        vim.cmd("NvimTreeFocus")
      end
    end,
  },
}
