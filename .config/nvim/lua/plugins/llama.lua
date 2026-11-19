-- Local tab completion with llama.cpp (brew "llama.cpp").
-- nvim starts llama-server on the first InsertEnter. The model unloads after
-- 10 idle minutes. Server log (warnings and errors, reset on each start):
-- ~/.local/state/nvim/llama-server.log
-- After `brew upgrade`, the next nvim replaces a server that runs an old build.
-- After changing the server flags, run `pkill llama-server`.
local port = 8012
local url = ("http://127.0.0.1:%d"):format(port)

-- The server is detached, so all nvim instances share it and it outlives them.
-- If two start it at once, the second cannot bind the port and exits.
local function start()
  local log = vim.fn.stdpath("state") .. "/llama-server.log"
  vim.fn.jobstart({
    "sh",
    "-c",
    'exec llama-server --fim-qwen-3b-default --port "$1" --sleep-idle-seconds 600 -lv 2 >"$2" 2>&1',
    "sh",
    tostring(port),
    log,
  }, { detach = true })
end

-- Stop the server on our port, then start a new one when the port is free.
local function restart(pid)
  vim.uv.kill(pid, "sigterm")
  local tries = 40
  local function wait()
    local tcp = vim.uv.new_tcp()
    tcp:connect("127.0.0.1", port, function(err)
      tcp:close()
      tries = tries - 1
      if err then
        vim.schedule(start)
      elseif tries > 0 then
        vim.defer_fn(wait, 250)
      end
    end)
  end
  wait()
end

-- Start llama-server if nothing answers on the port. Replace it if it runs
-- a different build than the installed binary (brew "build_info" format: b<build>-<commit>).
local function ensure_server()
  if vim.fn.executable("llama-server") == 0 then
    return
  end
  vim.system({ "curl", "-sf", "--max-time", "2", url .. "/props" }, { text = true }, function(props)
    if props.code ~= 0 then
      return vim.schedule(start)
    end
    local ok, data = pcall(vim.json.decode, props.stdout)
    local running = ok and type(data) == "table" and data.build_info
    if type(running) ~= "string" then
      return
    end
    vim.system({ "llama-server", "--version" }, { text = true }, function(version)
      local build, commit = (version.stderr or ""):match("build (%d+), commit (%x+)")
      if not build or running == ("b%s-%s"):format(build, commit) then
        return
      end
      vim.system({ "lsof", "-ti", "tcp:" .. port, "-sTCP:LISTEN" }, { text = true }, function(lsof)
        local pid = tonumber((lsof.stdout or ""):match("%d+"))
        if pid then
          vim.schedule(function()
            restart(pid)
          end)
        end
      end)
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
