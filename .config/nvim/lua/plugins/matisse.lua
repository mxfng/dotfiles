-- matisse: lets the matisse CLI (and the agents that call it) show you code
-- in this editor, and lets you review code back to them. The plugin lives in
-- its own repo; delete this file to take it out of nvim.
local dir = vim.fn.expand("~/Developer/matisse")

return {
  {
    dir = dir,
    name = "matisse",
    cond = vim.uv.fs_stat(dir) ~= nil,
    lazy = false,
    opts = {},
  },
  {
    -- The follow view's state: "hold · 3" while agent edits wait.
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 1, {
        function()
          return require("matisse").follow_status()
        end,
        cond = function()
          return package.loaded["matisse"] ~= nil and require("matisse").follow_status() ~= ""
        end,
      })
    end,
  },
}
