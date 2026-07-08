-- Jump between git worktrees to read code (e.g. what an agent is editing in a
-- sibling checkout). Logic lives in lua/util/worktree.lua; this just wires a
-- key and command onto snacks (always loaded under LazyVim).
return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gw", function() require("util.worktree").pick() end, desc = "Worktrees" },
    },
    init = function()
      vim.api.nvim_create_user_command("Worktrees", function()
        require("util.worktree").pick()
      end, { desc = "Switch git worktree" })
    end,
  },
}
