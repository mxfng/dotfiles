-- Ctrl-h/j/k/l move between Neovim splits and, at the edge, into the
-- neighboring tmux pane. tmux.conf has the matching half.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window or tmux pane left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window or tmux pane down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window or tmux pane up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window or tmux pane right" },
  },
}
