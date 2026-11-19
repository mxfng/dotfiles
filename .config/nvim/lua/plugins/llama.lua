-- Local tab completion with llama.cpp (brew "llama.cpp").
-- nvim starts llama-server on the first InsertEnter. The model unloads after
-- 10 idle minutes. Server log (warnings and errors, reset on each start):
-- ~/.local/state/nvim/llama-server.log
-- After changing the server flags or upgrading llama.cpp, run `pkill llama-server`.
-- The next InsertEnter starts the new server.
local port = 8012

-- Start llama-server unless something already listens on the port.
-- The server is detached, so all nvim instances share it and it outlives them.
-- If two start it at once, the second cannot bind the port and exits.
local function ensure_server()
  if vim.fn.executable("llama-server") == 0 then
    return
  end
  local tcp = vim.uv.new_tcp()
  tcp:connect("127.0.0.1", port, function(err)
    tcp:close()
    if not err then
      return
    end
    vim.schedule(function()
      local log = vim.fn.stdpath("state") .. "/llama-server.log"
      vim.fn.jobstart({
        "sh",
        "-c",
        'exec llama-server --fim-qwen-3b-default --port "$1" --sleep-idle-seconds 600 -lv 2 >"$2" 2>&1',
        "sh",
        tostring(port),
        log,
      }, { detach = true })
    end)
  end)
end

return {
  "ggml-org/llama.vim",
  event = "VeryLazy",
  init = function()
    vim.g.llama_config = {
      -- Defaults: Tab accepts all, S-Tab accepts one line.
      endpoint_fim = ("http://127.0.0.1:%d/infill"):format(port),
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
        if state then
          ensure_server()
        end
      end,
    }):map("<leader>at")

    vim.api.nvim_create_autocmd("InsertEnter", {
      once = true,
      callback = function()
        if enabled then
          ensure_server()
        end
      end,
    })
  end,
}
