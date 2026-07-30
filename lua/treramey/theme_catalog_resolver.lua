local source = debug.getinfo(1, "S").source:sub(2)
local config_root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(source)))
local Catalog = dofile(config_root .. "/lua/treramey/theme_catalog.lua")

local separator
for index, argument in ipairs(vim.v.argv) do
  if argument == "--" then
    separator = index
    break
  end
end

local input = separator and vim.v.argv[separator + 1] or nil
if not input or vim.v.argv[separator + 2] then
  vim.api.nvim_err_writeln "Invalid Neovim theme input"
  vim.cmd.cquit(1)
  return
end

local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand "~/.config"
local current_root = config_home .. "/omarchy/current"
local name_file = io.open(current_root .. "/theme.name", "r")
local current_name = name_file and name_file:read "*l" or nil
if name_file then
  name_file:close()
end

if current_name == input and vim.fn.filereadable(current_root .. "/theme/neovim.lua") == 1 then
  io.write(input .. "\n")
  return
end

local result = Catalog.resolve(input)
if result.ok then
  io.write(result.value.slug .. "\n")
  return
end

vim.api.nvim_err_writeln "Unsupported Neovim theme"
vim.cmd.cquit(1)
