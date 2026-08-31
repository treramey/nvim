local mason_opts = assert(_G.roslyn_test_mason_opts, "mason-tool-installer setup was not captured")
assert(not vim.tbl_contains(mason_opts.ensure_installed, "roslyn_ls"), "Mason must not own roslyn_ls")

local config = assert(vim.lsp.config.roslyn_ls, "roslyn_ls config was not registered")
assert(config.cmd_env.DOTNET_ROOT:match "/dotnet/10$", config.cmd_env.DOTNET_ROOT)
assert(config.cmd_env.DOTNET_ROOT_X64 == config.cmd_env.DOTNET_ROOT)
assert(config.cmd[2] == "-u" and config.cmd[3] == "__MISE_SHIM")
assert(config.cmd[4] == "DOTNET_ROOT=" .. config.cmd_env.DOTNET_ROOT)
assert(config.cmd[7]:match "/%.dotnet/tools/roslyn%-language%-server$")

local calls = {}
local callbacks = {}
local notifications = {}
local original_system = vim.system
local original_notify = vim.notify

vim.system = function(cmd, opts, callback)
  table.insert(calls, { cmd = cmd, opts = opts })
  table.insert(callbacks, callback)
  return {}
end
vim.notify = function(message, level)
  table.insert(notifications, { message = message, level = level })
end

vim.cmd "RoslynTool status"
assert(#calls == 1)
assert(calls[1].cmd[1]:match "/dotnet/10/dotnet$", calls[1].cmd[1])
assert(calls[1].opts.env.DOTNET_ROOT:match "/dotnet/10$")

vim.cmd "RoslynTool update"
assert(#calls == 1, "overlapping RoslynTool operations must be rejected")

callbacks[1] { code = 1, stdout = "", stderr = "SDK resolution failed" }
vim.wait(100, function()
  return vim.iter(notifications):any(function(item)
    return item.message == "SDK resolution failed"
  end)
end)
assert(
  vim.iter(notifications):any(function(item)
    return item.message == "SDK resolution failed" and item.level == vim.log.levels.ERROR
  end),
  "status failures must preserve the original error"
)

vim.system = original_system
vim.notify = original_notify
