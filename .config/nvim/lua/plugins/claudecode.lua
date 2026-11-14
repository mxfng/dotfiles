-- Claude terminal toggle omitted here, prefer the agent pane in tmux
-- claudecode.nvim starts a server that the tmux agent pane joins with `claude --ide`
-- so nvim integration holds.
return {
  "coder/claudecode.nvim",
  event = "VeryLazy", -- start the server with Neovim, not on first key
  opts = { terminal = { provider = "none" } },
  keys = {
    { "<leader>ac", false },
    { "<leader>af", false },
    { "<leader>ar", false },
    { "<leader>aC", false },
  },
}
