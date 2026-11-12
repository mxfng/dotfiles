-- Markdown here is written one sentence per line, so lines run long. Point
-- markdownlint (as linter and as formatter) at a config that turns the
-- line-length rule off; every other rule stays on.
local config = vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml"

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          -- nvim-lint pipes the buffer in; "-" reads it (its default args).
          args = { "--config", config, "-" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", config },
        },
      },
    },
  },
}
