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
}
