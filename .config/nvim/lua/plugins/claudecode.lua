-- Claude terminal toggle omitted here, prefer config's claude in tmux pane
-- claudecode.nvim starts a server that tmux claude joins with `claude --ide`
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
