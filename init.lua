vim.loader.enable()

_G.Config = {}

-- tree-sitter-cli defaults to MSVC on Windows, but the standalone LLVM
-- package does not include the Windows SDK headers. Prefer Scoop's MinGW GCC.
if vim.fn.has "win32" == 1 and not vim.env.CC then
  local gcc = vim.fn.exepath "gcc"
  local gxx = vim.fn.exepath "g++"
  if gcc == "" then
    gcc = vim.fs.joinpath(vim.env.USERPROFILE, "scoop/apps/gcc/current/bin/gcc.exe")
    gxx = vim.fs.joinpath(vim.env.USERPROFILE, "scoop/apps/gcc/current/bin/g++.exe")
  end
  if vim.fn.executable(gcc) == 1 then
    vim.env.CC = gcc
    vim.env.CXX = gxx
  end
end

-- `old_lua/` is reference-only while the vim.pack config is being built.
-- Do not add it to 'runtimepath'/'packpath'; Neovim only loads standard
-- runtime dirs like `plugin/`, `after/`, and `lua/`.
vim.opt.runtimepath:remove(vim.fn.stdpath "config" .. "/old_lua")
vim.opt.packpath:remove(vim.fn.stdpath "config" .. "/old_lua")

Config.gh = function(r)
  return "https://github.com/" .. r
end

vim.pack.add { Config.gh "nvim-mini/mini.nvim" }

local misc = require "mini.misc"
Config.now = function(f)
  misc.safely("now", f)
end
Config.later = function(f)
  misc.safely("later", f)
end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f)
  misc.safely("event:" .. ev, f)
end
Config.on_filetype = function(ft, f)
  misc.safely("filetype:" .. ft, f)
end

local gr = vim.api.nvim_create_augroup("custom-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback(ev.data)
  end
  Config.new_autocmd("PackChanged", "*", f, desc)
end
