-- Run with: nvim --headless -u NONE -i NONE -l tests/completion_keymaps_spec.lua
local source = debug.getinfo(1, "S").source:sub(2)
local root = vim.fs.dirname(vim.fs.dirname(vim.fn.fnamemodify(source, ":p")))
vim.cmd "packadd mini.nvim"
local child = require("mini.test").new_child_neovim()

local function expect(expression, expected)
  local actual = child.lua_get(expression)
  assert(vim.deep_equal(actual, expected), expression .. ": " .. vim.inspect { actual = actual, expected = expected })
end

local function reset(line)
  child.type_keys "<Esc>"
  child.lua [[
    while MiniSnippets.session.get() do MiniSnippets.session.stop() end
    vim.b.minicompletion_disable = true
  ]]
  child.api.nvim_buf_set_lines(0, 0, -1, false, { line or "" })
  child.type_keys "A"
end

local function complete()
  reset "a"
  child.lua [[vim.fn.complete(1, { 'alpha', 'alpine', 'amber' })]]
  expect("vim.fn.pumvisible()", 1)
  expect("vim.fn.complete_info().selected", -1)
end

local ok, err = xpcall(function()
  child.start {
    "--cmd",
    "set rtp^=" .. root .. " packpath^=" .. vim.fn.stdpath "data" .. "/site",
    "-u",
    root .. "/init.lua",
  }
  child.lua [[
    assert(vim.wait(5000, function()
      return _G.MiniCompletion ~= nil and _G.MiniSnippets ~= nil and _G.MiniKeymap ~= nil
    end), 'Completion setup did not finish')
    vim.cmd 'enew!'
  ]]

  complete()
  child.type_keys "<C-j>"
  expect("vim.fn.complete_info().selected", 0)
  child.type_keys "<Tab>"
  expect("vim.fn.complete_info().selected", 1)
  child.type_keys "<S-Tab>"
  expect("vim.fn.complete_info().selected", 0)
  child.type_keys "<C-j>"
  child.type_keys "<C-k>"
  expect("vim.fn.complete_info().selected", 0)
  child.type_keys "<C-j>"
  child.type_keys "<CR>"
  expect("vim.api.nvim_buf_get_lines(0, 0, -1, false)", { "alpine" })
  expect("vim.fn.pumvisible()", 0)
  expect("vim.fn.mode()", "i")

  complete()
  child.type_keys "<CR>"
  expect("vim.api.nvim_buf_get_lines(0, 0, -1, false)", { "alpha" })

  complete()
  child.type_keys "<C-j>"
  child.type_keys "<C-c>"
  expect("vim.api.nvim_get_current_line()", "a")
  expect("vim.fn.pumvisible()", 0)
  expect("vim.fn.mode()", "i")

  reset()
  child.type_keys "<CR>"
  expect("vim.api.nvim_buf_line_count(0)", 2)
  reset()
  child.type_keys "("
  child.type_keys "<CR>"
  expect("vim.api.nvim_buf_get_lines(0, 0, -1, false)", { "(", "", ")" })

  reset()
  child.lua [[MiniSnippets.default_insert({ body = '${1:first} ${2:second}$0' })]]
  expect("MiniSnippets.session.get().cur_tabstop", "1")
  child.type_keys "<Tab>"
  expect("MiniSnippets.session.get().cur_tabstop", "2")
  child.type_keys "<S-Tab>"
  expect("MiniSnippets.session.get().cur_tabstop", "1")

  reset()
  child.type_keys "<Tab>"
  expect("vim.api.nvim_get_current_line()", "  ")
  reset "text"
  child.type_keys "<C-j>"
  expect("vim.api.nvim_buf_get_lines(0, 0, -1, false)", { "text", "" })

  reset()
  child.lua [[
    _G.signature_calls = 0
    vim.lsp.buf.signature_help = function() signature_calls = signature_calls + 1 end
  ]]
  child.type_keys "<C-k>"
  expect("signature_calls", 1)
  child.type_keys "<C-c>"
  expect("vim.fn.mode()", "n")
end, debug.traceback)

child.stop()
assert(ok, err)
print "Completion keymap checks passed"
