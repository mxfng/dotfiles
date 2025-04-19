return { -- Shows indent guides with a vertical lin:w
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = 'BufReadPre',
  opts = {
    indent = { char = '│' },
    scope = { enabled = true },
  },
}
