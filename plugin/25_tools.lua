local is_running = false
local last_log = {}
local log_path = vim.fs.joinpath(vim.fn.stdpath "cache", "update-tools.log")

local shell_command = function(cmd)
  local parts = {}
  for _, arg in ipairs(cmd) do
    table.insert(parts, vim.fn.shellescape(arg))
  end
  return table.concat(parts, " ")
end

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

local update_steps = function()
  local steps = {
    { label = "Upgrading mise-managed tools", cmd = { "mise", "upgrade", "--yes" } },
    { label = "Installing configured mise tools", cmd = { "mise", "install" } },
    { label = "Refreshing mise shims", cmd = { "mise", "reshim" } },
  }

  if vim.fn.executable "dotnet" == 1 then
    vim.list_extend(steps, {
      {
        label = "Updating roslyn-language-server",
        cmd = { "dotnet", "tool", "update", "-g", "roslyn-language-server", "--prerelease" },
        allow_failure = true,
      },
      {
        label = "Updating dotnet-ef",
        cmd = { "dotnet", "tool", "update", "-g", "dotnet-ef" },
        allow_failure = true,
      },
      {
        label = "Updating EasyDotnet",
        cmd = { "dotnet", "tool", "update", "-g", "EasyDotnet" },
        allow_failure = true,
      },
    })
  else
    table.insert(last_log, "Skipped .NET global tools: dotnet is not executable.")
  end

  return steps
end

local finish_update = function(handle, code, message)
  is_running = false
  table.insert(last_log, "")
  table.insert(last_log, "UpdateTools exited with code " .. code)
  write_log()

  if handle then
    handle.message = message
    handle:finish()
  end

  if code == 0 then
    vim.notify("Tool update complete. Restart Neovim or run :LspRestart.", vim.log.levels.INFO)
  else
    vim.notify("Tool update failed. Run :UpdateToolsLog for output.", vim.log.levels.ERROR)
  end
end

local run_step
run_step = function(steps, index, handle)
  local step = steps[index]
  if not step then
    finish_update(handle, 0, "Complete")
    return
  end

  if handle then
    handle.message = step.label
  else
    vim.notify("UpdateTools: " .. step.label, vim.log.levels.INFO)
  end

  table.insert(last_log, "")
  table.insert(last_log, "$ " .. shell_command(step.cmd))

  vim.system(step.cmd, { text = true }, function(result)
    vim.schedule(function()
      append_text(result.stdout)
      append_text(result.stderr)

      if result.code ~= 0 and not step.allow_failure then
        table.insert(last_log, "")
        table.insert(last_log, string.format("%s failed with code %d.", step.label, result.code))
        finish_update(handle, result.code, "Failed")
        return
      end

      run_step(steps, index + 1, handle)
    end)
  end)
end

local open_tool_update = function()
  if is_running then
    vim.notify("Tool update is already running.", vim.log.levels.INFO)
    return
  end

  if not vim.system then
    vim.notify("UpdateTools requires vim.system.", vim.log.levels.ERROR)
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

  run_step(update_steps(), 1, handle)
end

pcall(vim.api.nvim_del_user_command, "ToolUpdate")
pcall(vim.api.nvim_del_user_command, "UpdateTools")
pcall(vim.api.nvim_del_user_command, "UpdateToolsLog")
vim.api.nvim_create_user_command("UpdateTools", open_tool_update, {
  desc = "Update mise-managed LSPs, formatters, and CLI tools",
})
vim.api.nvim_create_user_command("UpdateToolsLog", open_log, {
  desc = "Open the latest UpdateTools output",
})
