-- TypeScript Tools configuration

return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    settings = {
      -- TypeScript settings
      tsserver_plugins = {
        '@styled/typescript-styled-plugin',
      },
      tsserver_file_preferences = {
        includeInlayParameterHints = 'all',
        includeInlayParameterHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
      },
      tsserver_format = {
        indentSize = 2,
        convertTabsToSpaces = true,
        trimTrailingWhitespace = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
        insertSpaceAfterTypeAssertion = true,
        insertSpaceBeforeFunctionParenthesis = false,
        placeOpenBraceOnNewLineForFunctions = false,
        placeOpenBraceOnNewLineForControlBlocks = false,
        semicolons = 'insert',
      },
      tsserver_format_options = {
        allowRenameOfImportPath = true,
      },
    },
    -- LSP settings
    on_attach = function(client, bufnr)
      -- Add custom on_attach behavior here
    end,
    handlers = {
      -- Add custom handlers here
    },
  },
  config = function(_, opts)
    require('typescript-tools').setup(opts)
  end,
}
