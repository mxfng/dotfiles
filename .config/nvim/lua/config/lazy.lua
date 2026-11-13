local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- sync overwrites the deployed config, so write the lock straight into the
-- dotfiles repo where git can track it. Fall back when the repo is absent.
local repo_lock = vim.fn.expand("~/Developer/dotfiles/.config/nvim/lazy-lock.json")

require("lazy").setup({
  lockfile = vim.uv.fs_stat(repo_lock) and repo_lock or vim.fn.stdpath("config") .. "/lazy-lock.json",
  spec = {
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      -- sync overwrites lazyvim.json, where LazyVim records news already seen,
      -- so news would otherwise reopen on every start after a sync.
      opts = { news = { lazyvim = false, neovim = false } },
    },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { "tokyonight" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  rocks = {
    enabled = false,
  },
})
