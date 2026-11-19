-- Local tab completion with llama.cpp.
-- Start the server first: llama-server --fim-qwen-3b-default
return {
  "ggml-org/llama.vim",
  event = "VeryLazy",
  init = function()
    vim.g.llama_config = {
      -- Defaults: Tab accepts all, S-Tab accepts one line, server on 127.0.0.1:8012.
      show_info = 0, -- 1: stats in the statusline, 2: stats inline
    }
  end,
  config = function()
    -- The plugin hardcodes orange ghost text. Link to NonText: dimmer than comments and not italic, so it never looks like real code.
    local function hl()
      vim.api.nvim_set_hl(0, "llama_hl_fim_hint", { link = "NonText" })
    end
    hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = hl })

    -- <leader>at toggles suggestions. The plugin does not expose its state, so track it here.
    local enabled = true
    Snacks.toggle({
      name = "Tab Completion",
      get = function()
        return enabled
      end,
      set = function(state)
        vim.cmd(state and "LlamaEnable" or "LlamaDisable")
        enabled = state
      end,
    }):map("<leader>at")
  end,
}
