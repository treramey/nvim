-- Run with HERDR_ENV=1 nvim --headless -i NONE -c 'luafile tests/herdr_clipboard_spec.lua'.
local ok, err = pcall(function()
  assert(vim.env.HERDR_ENV == "1", "Run this check inside Herdr")
  vim.cmd "enew!"

  local cases = {
    {
      name = "linewise",
      lines = { "alpha", "beta" },
      yank = "gg0yy",
      paste = "Gp",
      expected = { "alpha", "beta", "alpha" },
      regtype = "V",
    },
    {
      name = "characterwise",
      lines = { "abcd" },
      yank = "gg0vly",
      paste = "$p",
      expected = { "abcdab" },
      regtype = "v",
    },
    {
      name = "blockwise",
      lines = { "abcd", "efgh" },
      yank = "gg0" .. vim.keycode "<C-v>" .. "jly",
      paste = "gg$p",
      expected = { "abcdab", "efghef" },
      regtype = vim.keycode "<C-v>" .. "2",
    },
  }

  for _, case in ipairs(cases) do
    vim.api.nvim_buf_set_lines(0, 0, -1, false, case.lines)
    vim.cmd.normal { case.yank, bang = true }
    local start = vim.uv.hrtime()
    local register = vim.g.clipboard.paste["+"]()
    assert((vim.uv.hrtime() - start) / 1e6 < 500, case.name .. " provider waited for a clipboard response")
    assert(
      vim.deep_equal(register, { vim.fn.getreg('"', 1, true), case.regtype }),
      case.name .. " provider changed register contents or type"
    )
    vim.cmd.normal { case.paste, bang = true }
    local elapsed_ms = (vim.uv.hrtime() - start) / 1e6
    assert(elapsed_ms < 500, case.name .. " paste waited for the terminal clipboard")
    assert(
      vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), case.expected),
      case.name .. " paste changed text or added blank lines"
    )
    assert(vim.fn.getregtype '"' == case.regtype, case.name .. " register type was lost")
  end
end)

if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd "cquit 1"
end

print "herdr_clipboard_spec: ok"
vim.cmd "qa!"
