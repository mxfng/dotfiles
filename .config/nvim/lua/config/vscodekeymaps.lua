if not vim.g.vscode then
  return
end

local function vsc(cmd)
  return function()
    vim.fn.VSCodeNotify(cmd)
  end
end

vim.keymap.set("n", "<leader>cr", vsc("editor.action.rename"), { desc = "Rename symbol" })
vim.keymap.set("n", "gd", vsc("editor.action.revealDefinition"), { desc = "Go to definition" })
vim.keymap.set("n", "gr", vsc("editor.action.referenceSearch.trigger"), { desc = "Find all references" })

vim.keymap.set("n", "<leader>sf", vsc("actions.find"), { desc = "Find in file" })
vim.keymap.set("n", "<leader>sr", vsc("editor.action.startFindReplaceAction"), { desc = "Find and replace in file" })
vim.keymap.set("n", "<leader>sF", vsc("workbench.action.findInFiles"), { desc = "Find in files" })

vim.keymap.set("n", "<leader><leader>", vsc("workbench.action.quickOpen"), { desc = "Quick open file" })
vim.keymap.set("n", "<S-h>", vsc("workbench.action.previousEditor"), { desc = "Previous file" })
vim.keymap.set("n", "<S-l>", vsc("workbench.action.nextEditor"), { desc = "Next file" })
