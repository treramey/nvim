local M = {}

-- Process names that identify an AI agent pane. Matched against both
-- `pane_current_command` (the live process) and `pane_start_command` (how the
-- pane was launched, e.g. tmux `bind P split-window ... pi`), so it works
-- whether the agent runs as a native binary or via a node/bun shim.
M.agent_commands = { "claude", "pi" }

--- Build the `@path:line` reference for the current buffer.
--- The path is made relative to nvim's cwd (`:.`), which matches the directory
--- the agent CLI was launched in, so `@path` resolves on the agent's side.
--- @return string|nil reference, or nil when the buffer has no file
local function build_reference()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return nil
  end
  local relative = vim.fn.fnamemodify(name, ":.")
  local line = vim.fn.line(".")
  return string.format("@%s:%d", relative, line)
end

--- @param command string|nil a tmux command field (may include args/path)
--- @return boolean whether it names a known agent
local function is_agent_command(command)
  if not command or command == "" then
    return false
  end
  -- Drop arguments, then strip any leading path to compare the bare name.
  local bare = command:match("^%s*(%S+)") or command
  bare = vim.fn.fnamemodify(bare, ":t")
  for _, agent in ipairs(M.agent_commands) do
    if bare == agent then
      return true
    end
  end
  return false
end

--- Find a tmux pane in the current session running an agent, preferring the
--- window nvim lives in.
--- @return string|nil pane id (e.g. "%3"), or nil when none is found
local function find_agent_pane()
  if not vim.env.TMUX then
    return nil
  end

  local self_pane = vim.env.TMUX_PANE
  local fmt = "#{pane_id}\t#{window_id}\t#{pane_current_command}\t#{pane_start_command}"
  local result = vim.system({ "tmux", "list-panes", "-s", "-F", fmt }, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end

  local self_window
  local candidates = {}
  for line in vim.gsplit(result.stdout or "", "\n", { trimempty = true }) do
    local pane_id, window_id, current_cmd, start_cmd = line:match("^(%S+)\t(%S+)\t([^\t]*)\t(.*)$")
    if pane_id then
      if pane_id == self_pane then
        self_window = window_id
      elseif is_agent_command(current_cmd) or is_agent_command(start_cmd) then
        table.insert(candidates, { pane_id = pane_id, window_id = window_id })
      end
    end
  end

  -- Prefer an agent sharing nvim's window before falling back to the session.
  for _, candidate in ipairs(candidates) do
    if candidate.window_id == self_window then
      return candidate.pane_id
    end
  end
  return candidates[1] and candidates[1].pane_id or nil
end

--- Copy the current buffer's `@path:line` to the system clipboard and, when an
--- agent pane is found in this tmux session, type the reference into it without
--- a trailing <CR> (so a prompt can be appended). Falls back to clipboard-only.
function M.send_path_to_agent()
  local reference = build_reference()
  if not reference then
    return
  end

  vim.fn.setreg("+", reference)

  local pane = find_agent_pane()
  if pane then
    -- `-l` sends the text literally; the trailing space separates it from a
    -- prompt the user types next.
    vim.system({ "tmux", "send-keys", "-t", pane, "-l", reference .. " " }):wait()
  end
end

vim.api.nvim_create_user_command("SendPathToAgent", function()
  M.send_path_to_agent()
end, { desc = "Copy @path:line and send it to a claude/pi tmux pane" })

return M
