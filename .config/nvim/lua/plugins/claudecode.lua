-- Claude runs in a tmux pane (prefix + a), not in a Neovim terminal.
-- claudecode.nvim stays for the link: it starts a server that the tmux
-- Claude joins with `claude --ide`, so <leader>as sends a selection,
-- <leader>ab adds the buffer, and diffs open in Neovim.
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
