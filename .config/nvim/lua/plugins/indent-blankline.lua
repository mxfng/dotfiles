-- Shows indent guides with a vertical line

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = 'BufReadPre',
  opts = {
    indent = { char = '│' },
    scope = { enabled = true },
  },
}
