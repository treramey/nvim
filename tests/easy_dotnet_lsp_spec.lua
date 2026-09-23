local mason_opts = assert(_G.easy_dotnet_lsp_test_mason_opts, "mason-tool-installer setup was not captured")
assert(not vim.tbl_contains(mason_opts.ensure_installed, "roslyn_ls"), "Mason must not own Roslyn")
assert(not vim.lsp.is_enabled "roslyn_ls", "nvim-lspconfig must not own Roslyn")
assert(vim.fn.exists ":RoslynTool" == 0, "the old standalone Roslyn manager must be removed")

local options = require("treramey.dotnet").easy_dotnet_options()
assert(options.lsp.enabled, "easy-dotnet must own the Roslyn LSP")
assert(not options.lsp.preload_roslyn, "Roslyn must start from a C# buffer")

if vim.fn.has "win32" == 1 then
  -- Windows prefers the native Program Files host over the mise shim.
  assert(vim.env.DOTNET_ROOT:match "[/\\]Program Files[/\\]dotnet$", vim.env.DOTNET_ROOT)
  assert(vim.env.DOTNET_ROOT_X64 == vim.env.DOTNET_ROOT)
  local result = vim.system({ "dotnet", "--version" }, { text = true }):wait()
  assert(result.code == 0 and result.stdout:match "^%d+%.%d+", result.stderr)
else
  assert(vim.env.DOTNET_ROOT:match "/dotnet/10$", "easy-dotnet Roslyn must use the .NET 10 runtime")
  assert(vim.env.DOTNET_ROOT_X64 == vim.env.DOTNET_ROOT)
end

assert(
  vim.wait(5000, function()
    return #vim.lsp.get_clients { name = "easy_dotnet", bufnr = 0, _uninitialized = true } > 0
  end),
  "easy-dotnet did not start Roslyn for the initial C# buffer"
)

local config = assert(vim.lsp.config.easy_dotnet, "easy-dotnet Roslyn config was not registered")
if vim.fn.has "win32" == 1 then
  assert(type(config.cmd) == "table" and #config.cmd > 0, "EasyDotnet must provide the Roslyn command")
else
  assert(vim.deep_equal(vim.list_slice(config.cmd, 1, 3), { "dotnet-easydotnet", "roslyn", "start" }))
end

print "easy_dotnet_lsp_spec: ok"
