-- Run with: nvim --headless -u NONE -i NONE -l tests/formatter_selection_spec.lua
local source = debug.getinfo(1, "S").source:sub(2)
local root = vim.fs.dirname(vim.fs.dirname(source))
vim.cmd "packadd conform.nvim"
local conform = require "conform"
Config = {
  gh = function(repo)
    return "https://github.com/" .. repo
  end,
  later = function(fn)
    fn()
  end,
}
local add = vim.pack.add
vim.pack.add = function() end
dofile(root .. "/plugin/23_format.lua")
vim.pack.add = add

local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp .. "/node_modules/.bin", "p")
local buf = vim.api.nvim_create_buf(false, false)
vim.api.nvim_buf_set_name(buf, tmp .. "/test.ts")
vim.bo[buf].filetype = "typescript"

local function executable(name)
  local path = tmp .. "/node_modules/.bin/" .. name
  vim.fn.writefile({ "#!/bin/sh", "cat" }, path)
  assert(vim.fn.setfperm(path, "rwx------") == 1)
end

local function selected(expected)
  local names = vim.tbl_map(function(info)
    return info.name
  end, conform.list_formatters(buf))
  assert(vim.deep_equal(names, expected), vim.inspect { expected = expected, actual = names })
end

local ok, err = xpcall(function()
  -- A globally installed formatter must not claim an unconfigured project.
  selected {}
  executable "biome"
  vim.fn.writefile({ "{}" }, tmp .. "/biome.json")
  selected { "biome", "biome-organize-imports" }

  -- Project-local Oxfmt wins, even without an Oxfmt config file.
  executable "oxfmt"
  selected { "oxfmt" }
  local info = conform.get_formatter_info("oxfmt", buf)
  assert(info.command == tmp .. "/node_modules/.bin/oxfmt", vim.inspect(info))

  vim.fn.delete(tmp .. "/node_modules/.bin/oxfmt")
  executable "vp"
  selected { "oxfmt" }
  info = conform.get_formatter_info("oxfmt", buf)
  assert(info.command == tmp .. "/node_modules/.bin/vp", vim.inspect(info))
  local config = conform.get_formatter_config "oxfmt"
  local ctx = { buf = buf, filename = tmp .. "/test.ts", dirname = tmp }
  assert(vim.deep_equal(config.args(config, ctx), { "fmt", "--stdin-filepath", "$FILENAME" }))

  -- Removing Vite+ restores the Biome pipeline rather than running both.
  vim.fn.delete(tmp .. "/node_modules/.bin/vp")
  selected { "biome", "biome-organize-imports" }
end, debug.traceback)

vim.api.nvim_buf_delete(buf, { force = true })
vim.fn.delete(tmp, "rf")
assert(ok, err)
print "Formatter selection checks passed"
