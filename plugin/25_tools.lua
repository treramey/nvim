local is_running = false
local is_roslyn_tool_running = false
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

-- All dotnet SDK versions install into one shared dotnet-root
-- (settings.dotnet.isolated = false in the mise config). Parallel installs
-- overwrite the shared host binary mid-run and corrupt it — macOS then
-- SIGKILLs dotnet with "Code Signature Invalid" — so the dotnet step runs
-- first with its installs serialized.
local dotnet_install_jobs = "1"

-- Extra args after the tool name are passed to `dotnet tool update`.
local dotnet_global_tools = {
  { "dotnet-ef" },
  { "EasyDotnet" },
}

local roslyn_feed = "https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json"
local roslyn_tool = "roslyn-language-server"
local roslyn_dotnet_root = vim.fn.expand "$HOME/.local/share/mise/installs/dotnet/10"
local roslyn_dotnet = vim.fs.joinpath(roslyn_dotnet_root, "dotnet")

local restart_lsp = function()
  if vim.fn.exists ":LspRestart" == 2 then
    vim.cmd "LspRestart"
    return
  end

  for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop(true)
  end

  vim.defer_fn(function()
    pcall(vim.cmd, "doautoall FileType")
  end, 100)
end

local roslyn_buffers = function()
  local buffers = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == "roslyn_ls" or client.name == "roslyn" then
      for buf in pairs(client.attached_buffers or {}) do
        buffers[buf] = true
      end
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "cs" then
      buffers[buf] = true
    end
  end
  return buffers
end

local stop_roslyn = function(restart)
  local buffers = restart and roslyn_buffers() or nil
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == "roslyn_ls" or client.name == "roslyn" then
      client:stop(false)
    end
  end

  if restart and next(buffers) then
    vim.defer_fn(function()
      for buf in pairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
          vim.api.nvim_buf_call(buf, function()
            pcall(vim.cmd, "LspStart roslyn_ls")
          end)
        end
      end
    end, 500)
  end
end

local manage_roslyn = function(opts)
  if is_roslyn_tool_running then
    vim.notify("A RoslynTool operation is already running.", vim.log.levels.INFO)
    return
  end

  if vim.fn.executable(roslyn_dotnet) ~= 1 then
    vim.notify("RoslynTool requires mise-managed .NET 10.", vim.log.levels.ERROR)
    return
  end

  local action = opts.args ~= "" and opts.args or "status"
  local commands = {
    install = { roslyn_dotnet, "tool", "install", "--global", roslyn_tool, "--prerelease", "--source", roslyn_feed },
    update = { roslyn_dotnet, "tool", "update", "--global", roslyn_tool, "--prerelease", "--source", roslyn_feed },
    uninstall = { roslyn_dotnet, "tool", "uninstall", "--global", roslyn_tool },
    status = { roslyn_dotnet, "tool", "list", "--global" },
  }
  local cmd = commands[action]
  if not cmd then
    vim.notify("Unknown RoslynTool action: " .. action, vim.log.levels.ERROR)
    return
  end

  is_roslyn_tool_running = true
  vim.notify("RoslynTool: " .. action .. "…", vim.log.levels.INFO)
  vim.system(cmd, {
    text = true,
    env = vim.tbl_extend("force", vim.fn.environ(), {
      DOTNET_ROOT = roslyn_dotnet_root,
      DOTNET_ROOT_X64 = roslyn_dotnet_root,
    }),
  }, function(result)
    vim.schedule(function()
      is_roslyn_tool_running = false
      local raw_output = vim.trim((result.stdout or "") .. (result.stderr or ""))

      if result.code ~= 0 then
        vim.notify(raw_output ~= "" and raw_output or "RoslynTool failed.", vim.log.levels.ERROR)
        return
      end

      local output = raw_output
      if action == "status" then
        local lines = vim.split(output, "\n", { plain = true })
        output = table.concat(
          vim.tbl_filter(function(line)
            return line:lower():find("roslyn", 1, true) or line:find("Package Id", 1, true)
          end, lines),
          "\n"
        )
        if not output:lower():find("roslyn", 1, true) then
          output = "roslyn-language-server is not installed as a global dotnet tool."
        end
      end

      if action == "install" or action == "update" then
        stop_roslyn(true)
      elseif action == "uninstall" then
        stop_roslyn(false)
      end
      vim.notify(output ~= "" and output or ("RoslynTool " .. action .. " complete."), vim.log.levels.INFO)
    end)
  end)
end

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

  if vim.fn.executable "dotnet" ~= 1 then
    table.insert(last_log, "Skipped .NET global tools: dotnet is not executable.")
    return steps
  end

  for _, tool in ipairs(dotnet_global_tools) do
    table.insert(steps, {
      label = "Updating " .. tool[1],
      cmd = vim.list_extend({ "dotnet", "tool", "update", "--global" }, tool),
      allow_failure = true,
    })
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
    restart_lsp()
    vim.notify("Tool update complete. LSP clients restarted.", vim.log.levels.INFO)
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
  table.insert(last_log, "$ " .. shell_command(step.cmd))

  vim.system(step.cmd, { text = true }, function(result)
    vim.schedule(function()
      append_text(result.stdout)
      append_text(result.stderr)

      if result.code ~= 0 then
        table.insert(last_log, "")
        table.insert(last_log, string.format("%s failed with code %d.", step.label, result.code))
        if step.allow_failure then
          table.insert(last_log, "Continuing because this step is optional.")
        else
          table.insert(failed, step.label)
        end
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

  if not vim.system then
    vim.notify("UpdateTools requires vim.system.", vim.log.levels.ERROR)
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

pcall(vim.api.nvim_del_user_command, "ToolUpdate")
pcall(vim.api.nvim_del_user_command, "UpdateTools")
pcall(vim.api.nvim_del_user_command, "UpdateToolsLog")
pcall(vim.api.nvim_del_user_command, "RoslynTool")
vim.api.nvim_create_user_command("UpdateTools", open_tool_update, {
  desc = "Update mise-managed formatters and CLI tools",
})
vim.api.nvim_create_user_command("UpdateToolsLog", open_log, {
  desc = "Open the latest UpdateTools output",
})
vim.api.nvim_create_user_command("RoslynTool", manage_roslyn, {
  nargs = "?",
  complete = function()
    return { "install", "update", "uninstall", "status" }
  end,
  desc = "Install, update, uninstall, or inspect roslyn-language-server",
})
