-- Git worktree browsing: jump between worktrees to read code (e.g. what an
-- agent is working on in a sibling checkout) without leaving nvim.
--
-- Switching worktrees just moves nvim's cwd; it deliberately does NOT try to
-- migrate open buffers or restart LSP. Each file you open picks up the right
-- LSP root on its own (lspconfig re-detects `.git` per worktree), so browsing a
-- second worktree spins up a second, correctly-rooted client with no fuss.

local M = {}

-- Directory to run git from: the current buffer's dir if it's a real file,
-- otherwise the editor cwd.
local function git_dir()
  local buf = vim.api.nvim_buf_get_name(0)
  if buf ~= "" and vim.uv.fs_stat(buf) then
    return vim.fs.dirname(buf)
  end
  return vim.fn.getcwd()
end

-- Parse `git worktree list --porcelain` into a list of records.
function M.list()
  local dir = git_dir()
  local out = vim.fn.systemlist({ "git", "-C", dir, "worktree", "list", "--porcelain" })
  if vim.v.shell_error ~= 0 then
    return {}, table.concat(out, "\n")
  end

  local cwd = vim.fs.normalize(vim.fn.getcwd())
  local worktrees, cur = {}, nil
  for _, line in ipairs(out) do
    if line:match("^worktree ") then
      cur = { path = vim.fs.normalize(line:sub(10)) }
      table.insert(worktrees, cur)
    elseif cur then
      if line:match("^HEAD ") then
        cur.head = line:sub(6, 12)
      elseif line:match("^branch ") then
        cur.branch = line:sub(8):gsub("^refs/heads/", "")
      elseif line == "bare" then
        cur.bare = true
      elseif line == "detached" then
        cur.detached = true
      end
    end
  end

  for _, w in ipairs(worktrees) do
    w.label = w.branch or (w.detached and ("(detached " .. (w.head or "?") .. ")")) or "(bare)"
    w.is_current = cwd == w.path or vim.startswith(cwd .. "/", w.path .. "/")
  end
  return worktrees
end

-- Longest worktree path that contains `path`, or nil.
local function containing(worktrees, path)
  local best
  path = vim.fs.normalize(path)
  for _, w in ipairs(worktrees) do
    if path == w.path or vim.startswith(path .. "/", w.path .. "/") then
      if not best or #w.path > #best.path then
        best = w
      end
    end
  end
  return best
end

-- Switch cwd to `target` (a worktree record). If the file open in the current
-- buffer also exists in the target worktree, reopen it there at the same line;
-- otherwise drop into a file picker rooted at the new worktree.
function M.switch(target)
  if not target or not target.path then
    return
  end
  if not vim.uv.fs_stat(target.path) then
    vim.notify("worktree gone: " .. target.path, vim.log.levels.WARN)
    return
  end

  -- Try to carry the current file across to the same relative path.
  local buf = vim.api.nvim_buf_get_name(0)
  local twin
  if buf ~= "" then
    local src = containing(M.list(), buf)
    if src and src.path ~= target.path then
      local rel = buf:sub(#src.path + 2)
      local candidate = target.path .. "/" .. rel
      if vim.uv.fs_stat(candidate) then
        twin = candidate
      end
    end
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd.cd(vim.fn.fnameescape(target.path))
  vim.notify("worktree: " .. target.label .. "  " .. vim.fn.fnamemodify(target.path, ":~"))

  if twin then
    vim.cmd.edit(vim.fn.fnameescape(twin))
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
  elseif package.loaded.snacks then
    require("snacks").picker.files({ cwd = target.path })
  end
end

-- snacks picker over the worktrees.
function M.pick()
  local worktrees = M.list()
  if #worktrees == 0 then
    vim.notify("no git worktrees here", vim.log.levels.WARN)
    return
  end

  require("snacks").picker.pick({
    source = "worktrees",
    items = vim.tbl_map(function(w)
      return { text = w.label .. " " .. w.path, worktree = w }
    end, worktrees),
    format = function(item)
      local w = item.worktree
      local ret = {}
      ret[#ret + 1] = { w.is_current and "● " or "  ", "SnacksPickerGitBranchCurrent" }
      ret[#ret + 1] = { ("%-28s"):format(w.label), "SnacksPickerGitBranch" }
      ret[#ret + 1] = { vim.fn.fnamemodify(w.path, ":~"), "SnacksPickerDir" }
      return ret
    end,
    confirm = function(picker, item)
      picker:close()
      M.switch(item.worktree)
    end,
  })
end

return M
