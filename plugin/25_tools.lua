local is_running = false
local last_log = {}
local log_path = vim.fs.joinpath(vim.fn.stdpath "cache", "update-tools.log")

local append_text = function(text)
  if not text or text == "" then
    return
  end

  local lines = vim.split(text, "\n", { plain = true, trimempty = false })
  if lines[#lines] == "" then
    table.remove(lines, #lines)
  end

  vim.list_extend(last_log, lines)
end

local write_log = function()
  vim.fn.mkdir(vim.fs.dirname(log_path), "p")
  vim.fn.writefile(last_log, log_path)
end

local open_log = function()
  local lines = last_log
  if #lines == 0 and vim.fn.filereadable(log_path) == 1 then
    lines = vim.fn.readfile(log_path)
  end

  if #lines == 0 then
    lines = { "No UpdateTools log yet." }
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "log"
  vim.bo[buf].swapfile = false
  pcall(vim.api.nvim_buf_set_name, buf, "UpdateTools log")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  vim.cmd "botright split"
  vim.api.nvim_win_set_buf(0, buf)
end

local create_progress_handle = function()
  local ok, progress = pcall(require, "fidget.progress")
  if not ok then
    return nil
  end

  return progress.handle.create {
    title = "Update tools",
    message = "Starting...",
    lsp_client = { name = "tool-update" },
  }
end

-- All dotnet SDK versions install into one shared dotnet-root
-- (settings.dotnet.isolated = false in the mise config). Parallel installs
-- overwrite the shared host binary mid-run and corrupt it — macOS then
-- SIGKILLs dotnet with "Code Signature Invalid" — so the dotnet step runs
-- first with its installs serialized.
local dotnet_install_jobs = "1"

-- Extra args after the tool name are passed to `dotnet tool update`.
local dotnet_global_tools = {
  { "roslyn-language-server", "--prerelease" },
  { "dotnet-ef" },
  { "EasyDotnet" },
}

local update_steps = function()
  local steps = {
    {
      label = "Upgrading dotnet SDKs (serialized)",
      cmd = { "mise", "upgrade", "--yes", "--jobs", dotnet_install_jobs, "dotnet" },
    },
    { label = "Upgrading mise-managed tools", cmd = { "mise", "upgrade", "--yes" } },
    { label = "Installing configured mise tools", cmd = { "mise", "install", "--yes" } },
    { label = "Refreshing mise shims", cmd = { "mise", "reshim" } },
  }

  if vim.fn.executable "dotnet" == 1 then
    for _, tool in ipairs(dotnet_global_tools) do
      table.insert(steps, {
        label = "Updating " .. tool[1],
        cmd = vim.list_extend({ "dotnet", "tool", "update", "--global" }, tool),
      })
    end
  else
    table.insert(last_log, "Skipped .NET global tools: dotnet is not executable.")
  end

  return steps
end

local finish_update = function(handle, failed)
  is_running = false
  table.insert(last_log, "")
  if #failed == 0 then
    table.insert(last_log, "UpdateTools finished with no failures.")
  else
    table.insert(last_log, "UpdateTools finished with failed steps:")
    for _, label in ipairs(failed) do
      table.insert(last_log, "  - " .. label)
    end
  end
  write_log()

  if handle then
    handle.message = #failed == 0 and "Complete" or "Finished with failures"
    handle:finish()
  end

  if #failed == 0 then
    vim.notify("Tool update complete. Restart Neovim or run :LspRestart.", vim.log.levels.INFO)
  else
    local message = string.format("Tool update finished; %d step(s) failed. Run :UpdateToolsLog for output.", #failed)
    vim.notify(message, vim.log.levels.ERROR)
  end
end

local run_step
run_step = function(steps, index, handle, failed)
  local step = steps[index]
  if not step then
    finish_update(handle, failed)
    return
  end

  if handle then
    handle.message = step.label
  else
    vim.notify("UpdateTools: " .. step.label, vim.log.levels.INFO)
  end

  table.insert(last_log, "")
  table.insert(last_log, "$ " .. table.concat(step.cmd, " "))

  vim.system(step.cmd, { text = true }, function(result)
    vim.schedule(function()
      append_text(result.stdout)
      append_text(result.stderr)

      if result.code ~= 0 then
        table.insert(last_log, "")
        table.insert(last_log, string.format("%s failed with code %d.", step.label, result.code))
        table.insert(failed, step.label)
      end

      run_step(steps, index + 1, handle, failed)
    end)
  end)
end

local open_tool_update = function()
  if is_running then
    vim.notify("Tool update is already running.", vim.log.levels.INFO)
    return
  end

  -- vim.system() throws on a missing executable, which would leave
  -- is_running stuck; fail with a clear message instead.
  if vim.fn.executable "mise" ~= 1 then
    vim.notify("UpdateTools requires mise on PATH.", vim.log.levels.ERROR)
    return
  end

  is_running = true
  last_log = {
    "UpdateTools started at " .. os.date "%Y-%m-%d %H:%M:%S",
  }

  local handle = create_progress_handle()
  if not handle then
    vim.notify("UpdateTools: starting...", vim.log.levels.INFO)
  end

  run_step(update_steps(), 1, handle, {})
end

vim.api.nvim_create_user_command("UpdateTools", open_tool_update, {
  desc = "Update mise-managed LSPs, formatters, and CLI tools",
})
vim.api.nvim_create_user_command("UpdateToolsLog", open_log, {
  desc = "Open the latest UpdateTools output",
})
