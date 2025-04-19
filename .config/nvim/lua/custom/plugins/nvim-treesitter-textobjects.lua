return { -- Enhances text object selection using treesitter
  -- Provides more precise text object selection based on the language's syntax
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter.configs').setup {
      textobjects = {
        enable = true,
      },
    }
  end,
}
