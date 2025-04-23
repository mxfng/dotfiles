if vim.loader then
  vim.loader.enable()
end

-- Show sources if multiple LSPs
vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
  },
  float = {
    source = true,
  },
})

require("config.lazy")
