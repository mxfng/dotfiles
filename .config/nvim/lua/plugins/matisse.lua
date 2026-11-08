-- matisse: lets the matisse CLI (and the agents that call it) show you code
-- in this editor. The plugin lives in its own repo; delete this file to take
-- it out of nvim.
local dir = vim.fn.expand("~/Developer/matisse")

return {
  {
    dir = dir,
    name = "matisse",
    cond = vim.uv.fs_stat(dir) ~= nil,
    lazy = false,
    opts = {},
  },
}
