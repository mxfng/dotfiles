local keymap = vim.keymap

-- Default options for all mappings
local default_opts = { noremap = true, silent = true }

-- Helper function to create keymap with description
local function map(mode, lhs, rhs, desc)
  keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Basic operations
map("n", "x", '"_x', "Delete without yanking")

-- Increment/decrement
map("n", "+", "<C-a>", "Increment number")
map("n", "-", "<C-x>", "Decrement number")

-- Select all
map("n", "gA", "ggVG", "Select all text")
map("n", "gyA", "ggVGy", "Select all text and yank")

-- Save file and quit
map("n", "<Leader>w", ":update<Return>", "Save file")
map("n", "<Leader>q", ":quit<Return>", "Quit")
map("n", "<Leader>Q", ":qa<Return>", "Quit all")

-- File explorer with NvimTree
map("n", "<Leader>f", ":NvimTreeFindFile<Return>", "Find in NvimTree")
map("n", "<Leader>t", ":NvimTreeToggle<Return>", "Toggle NvimTree")

-- Tabs
map("n", "te", ":tabedit", "New tab")
map("n", "<tab>", ":tabnext<Return>", "Next tab")
map("n", "<s-tab>", ":tabprev<Return>", "Previous tab")
map("n", "tw", ":tabclose<Return>", "Close tab")

-- Split window
map("n", "ss", ":split<Return>", "Horizontal split")
map("n", "sv", ":vsplit<Return>", "Vertical split")

-- Move window
map("n", "sh", "<C-w>h", "Go to left window")
map("n", "sk", "<C-w>k", "Go to top window")
map("n", "sj", "<C-w>j", "Go to bottom window")
map("n", "sl", "<C-w>l", "Go to right window")

-- Resize window
map("n", "<C-S-h>", "<C-w><", "Decrease width")
map("n", "<C-S-l>", "<C-w>>", "Increase width")
map("n", "<C-S-k>", "<C-w>+", "Increase height")
map("n", "<C-S-j>", "<C-w>-", "Decrease height")
