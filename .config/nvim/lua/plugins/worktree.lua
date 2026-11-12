return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      {
        "<leader>gw",
        function()
          require("fzf-lua").git_worktrees()
        end,
        desc = "Worktrees",
      },
    },
  },
}
