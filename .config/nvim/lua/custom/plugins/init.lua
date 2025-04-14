-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    config = function()
      local jdtls = require 'jdtls'
      local root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' }

      if root_dir then
        jdtls.start_or_attach { root_dir = root_dir }
      end
    end,
  },
}
