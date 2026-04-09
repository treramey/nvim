local M = {}

M.run = function()
  local groups = {
    -- Statusline
    { name = "StatuslineModeNormal", expect = { "fg", "bold" } },
    { name = "StatuslineModeInsert", expect = { "fg", "bold" } },
    { name = "StatuslineModeVisual", expect = { "fg", "bold" } },
    { name = "StatuslineModeCommand", expect = { "fg", "bold" } },
    { name = "StatuslineModeReplace", expect = { "fg", "bold" } },
    { name = "StatuslineModeOther", expect = { "fg", "bold" } },
    { name = "StatuslineTextMain", expect = { "fg" } },
    { name = "StatuslineTextAccent", expect = { "fg" } },
    { name = "StatuslineFilepath", expect = { "fg" } },
    -- General
    { name = "IndentLineCurrent", expect = { "fg" } },
    { name = "MatchParen", expect = { "fg" } },
    -- Snacks
    { name = "SnacksDashboardDesc", expect = { "fg" } },
    { name = "SnacksIndentScope", expect = { "fg" } },
    -- Oil
    { name = "OilGitAdded", expect = { "fg" } },
    { name = "OilGitModified", expect = { "fg" } },
    -- Diff
    { name = "DiffAdd", expect = { "bg" } },
    { name = "DiffDelete", expect = { "bg" } },
  }

  local pass, fail = 0, 0
  for _, g in ipairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = g.name, link = false })
    local missing = {}
    for _, key in ipairs(g.expect) do
      if not hl[key] and key ~= "bold" then
        table.insert(missing, key)
      elseif key == "bold" and not hl.bold then
        table.insert(missing, key)
      end
    end
    if #missing > 0 then
      fail = fail + 1
      vim.api.nvim_echo({
        { "  FAIL ", "DiagnosticError" },
        { g.name, "Normal" },
        { " missing: " .. table.concat(missing, ", "), "Comment" },
      }, true, {})
    else
      pass = pass + 1
      local fg_str = hl.fg and string.format("#%06x", hl.fg) or "-"
      local bg_str = hl.bg and string.format("#%06x", hl.bg) or "-"
      vim.api.nvim_echo({
        { "  PASS ", "DiagnosticOk" },
        { g.name, "Normal" },
        { " fg=" .. fg_str .. " bg=" .. bg_str, "Comment" },
      }, true, {})
    end
  end

  vim.api.nvim_echo({ { "" } }, true, {})
  local summary_hl = fail > 0 and "DiagnosticError" or "DiagnosticOk"
  vim.api.nvim_echo({
    { string.format("  %d passed, %d failed", pass, fail), summary_hl },
  }, true, {})
end

return M
