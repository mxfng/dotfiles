-- matisse: lets the matisse CLI (and the agents that call it) show you code
-- in this editor, and lets you review code back to them. The plugin lives in
-- its own repo; delete this file to take it out of nvim.
local dir = vim.fn.expand("~/Developer/matisse")

local function m(fn)
  return function()
    require("matisse")[fn]()
  end
end

return {
  {
    dir = dir,
    name = "matisse",
    cond = vim.uv.fs_stat(dir) ~= nil,
    lazy = false,
    opts = {},
    keys = {
      { "<leader>m", "", desc = "+matisse", mode = { "n", "x" } },
      { "<leader>mc", m("comment"), desc = "Comment", mode = { "n", "x" } },
      { "<leader>md", m("delete"), desc = "Delete comment" },
      { "<leader>ml", m("list"), desc = "List comments" },
      { "<leader>ms", m("review"), desc = "Submit review" },
    },
  },
}
