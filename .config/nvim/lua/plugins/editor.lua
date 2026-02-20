return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { ";f", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { ";r", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
      { "\\\\", "<cmd>FzfLua buffers<cr>", desc = "List buffers" },
      { ";;", "<cmd>FzfLua resume<cr>", desc = "Resume picker" },
      { ";e", "<cmd>FzfLua diagnostics_document<cr>", desc = "List diagnostics" },
    },
  },

  -- Disable mini.surround (LazyVim default)
  { "nvim-mini/mini.surround", enabled = false },

  -- nvim.surround: chosen initially for cs/ds/ys commands (e.g. cs" or cst)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Disable Flash (ships in LazyVim core feature set)
  { "folke/flash.nvim", enabled = false },
}
