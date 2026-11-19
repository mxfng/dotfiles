-- Ctrl-h/j/k/l move between Neovim splits and, at the edge, into the
-- neighboring tmux pane. tmux.conf has the matching half.
local dirs = { h = "Left", j = "Down", k = "Up", l = "Right" }

-- LazyVim maps Ctrl-hjkl in the snacks terminal to a plain `wincmd`, and the
-- snacks explorer list maps Ctrl-j/k to list_down/up. Neither hands off to
-- tmux, so point both at the navigator too.
local term_keys, explorer_keys = {}, {}
for key, dir in pairs(dirs) do
  local cmd = "TmuxNavigate" .. dir
  -- A floating terminal has no neighbors, so pass the key through to it.
  term_keys["nav_" .. key] = {
    "<C-" .. key .. ">",
    function(self)
      if self:is_floating() then
        return "<C-" .. key .. ">"
      end
      vim.schedule(function()
        vim.cmd(cmd)
      end)
    end,
    expr = true,
    mode = "t",
    desc = "Window or tmux pane " .. dir:lower(),
  }
  -- The explorer list is a float inside a sidebar split. `wincmd` from a
  -- float lands in the editor window, so the navigator never sees the edge.
  -- Look for the neighbor from the sidebar split instead. Focusing that split
  -- does not work: snacks sends focus straight back to the list.
  explorer_keys["<C-" .. key .. ">"] = {
    function()
      local parent = vim.api.nvim_win_get_config(0).win
      if not (parent and vim.api.nvim_win_is_valid(parent)) then
        return vim.cmd(cmd)
      end
      local nr = vim.api.nvim_win_call(parent, function()
        return vim.fn.winnr(key)
      end)
      if nr ~= vim.fn.win_id2win(parent) then
        vim.api.nvim_set_current_win(vim.fn.win_getid(nr))
      elseif vim.env.TMUX then
        vim.fn.system({ "tmux", "select-pane", "-" .. ("LDUR"):sub(("hjkl"):find(key)) })
      end
    end,
    mode = { "n" },
    desc = "Window or tmux pane " .. dir:lower(),
  }
end

return {
  {
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
  },
  {
    "folke/snacks.nvim",
    opts = {
      terminal = { win = { keys = term_keys } },
      picker = {
        sources = {
          explorer = { win = { list = { keys = explorer_keys } } },
        },
      },
    },
  },
}
