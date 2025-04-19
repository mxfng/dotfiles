-- This file exports all plugins from the plugins directory
local plugins = {}

-- Import all plugins from this directory
for _, file in ipairs(vim.fn.glob(vim.fn.stdpath('config') .. '/lua/plugins/*.lua', false, true)) do
  local name = vim.fn.fnamemodify(file, ':t:r')
  if name ~= 'init' then
    local plugin = require('plugins.' .. name)
    if type(plugin) == 'table' then
      table.insert(plugins, plugin)
    end
  end
end

return plugins 