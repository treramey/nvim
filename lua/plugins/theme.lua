local function get_hl(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  return ok and hl or {}
end

local function patch_bg_none(name)
  local hl = get_hl(name)
  hl.bg = nil
  hl.ctermbg = nil
  vim.api.nvim_set_hl(0, name, hl)
end

local function set_custom_highlights()
  local function get_fg(name)
    return get_hl(name).fg
  end

  local function get_bg(name)
    return get_hl(name).bg
  end

  -- stylua: ignore start
  local gold    = get_fg("DiagnosticWarn")
  local love    = get_fg("DiagnosticError")
  local foam    = get_fg("DiagnosticInfo")
  local pine    = get_fg("Conditional")
  local iris    = get_fg("PreProc")
  local rose    = get_fg("Boolean")
  local muted   = get_fg("NonText")
  local subtle  = get_fg("Comment")
  local text    = get_fg("Normal")
  local overlay = get_bg("CursorLine")
  local surface = get_bg("ColorColumn")
  local base    = get_fg("IncSearch")
  -- stylua: ignore end

  if not (gold and love and foam and pine and iris and rose and muted and text) then
    return
  end

  local hl = vim.api.nvim_set_hl

  -- Transparency: patch bg only, preserve theme fg/styles
  -- stylua: ignore start
  local transparent_groups = {
    "Normal", "NormalNC", "NormalFloat", "NormalSB",
    "FloatBorder", "FloatTitle", "FloatFooter",
    "StatusLine", "StatusLineNC",
    "WinBar", "WinBarNC",
    "Pmenu", "PmenuSbar", "PmenuBorder",
    "SignColumn", "FoldColumn", "EndOfBuffer",
  }
  -- stylua: ignore end
  for _, group in ipairs(transparent_groups) do
    patch_bg_none(group)
  end

  -- Selection needs a visible bg
  if overlay then
    hl(0, "PmenuSel", vim.tbl_extend("force", get_hl("PmenuSel"), { bg = overlay }))
  end

  -- Link blink groups to base groups instead of redefining
  hl(0, "BlinkCmpMenu", { link = "Pmenu" })
  hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
  hl(0, "BlinkCmpMenuSelection", { link = "PmenuSel" })
  hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
  hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
  hl(0, "BlinkCmpDocSeparator", { link = "FloatBorder" })

  hl(0, "IndentLineCurrent", { fg = muted })
  hl(0, "MatchParen", { fg = love, bg = love, blend = 25 })
  hl(0, "QuickFixFilename", { fg = text })

  -- Dart (tabline)
  -- hl(0, "DartCurrentLabel", { fg = gold, bg = overlay, bold = true })
  -- hl(0, "DartCurrentLabelModified", { fg = gold, bg = overlay, bold = true })
  -- hl(0, "DartCurrentModified", { fg = text, bg = overlay, bold = true })
  -- hl(0, "DartMarkedCurrentLabel", { fg = gold, bg = overlay, bold = true })
  -- hl(0, "DartMarkedCurrentLabelModified", { fg = gold, bg = overlay, bold = true })
  -- hl(0, "DartMarkedCurrentModified", { fg = text, bg = overlay, bold = true })
  -- hl(0, "DartMarkedLabel", { fg = gold, bg = surface, bold = true })
  -- hl(0, "DartMarkedLabelModified", { fg = gold, bg = text, bold = true })
  -- hl(0, "DartPickLabel", { fg = gold, bold = true })
  -- hl(0, "DartVisibleLabel", { fg = gold, bg = surface, bold = true })
  -- hl(0, "DartVisibleLabelModified", { fg = gold, bg = text, bold = true })

  -- EasyDotnet
  -- hl(0, "EasyDotnetDebuggerFloatVariable", { fg = text, bg = overlay })
  -- hl(0, "EasyDotnetDebuggerVirtualException", { fg = love, italic = true })
  -- hl(0, "EasyDotnetDebuggerVirtualVariable", { fg = iris, italic = true })
  -- hl(0, "EasyDotnetTestRunnerProject", { fg = rose })
  -- hl(0, "EasyDotnetTestRunnerSolution", { fg = pine })
  -- hl(0, "EasyDotnetTestRunnerTest", { fg = iris })

  -- Oil
  hl(0, "OilGitAdded", { fg = foam })
  hl(0, "OilGitModified", { fg = rose })
  hl(0, "OilGitRenamed", { fg = pine })
  hl(0, "OilGitUntracked", { fg = subtle })
  hl(0, "OilGitIgnored", { fg = muted })

  -- RenderMarkdown
  hl(0, "RenderMarkdownCode", { bg = overlay })
  hl(0, "RenderMarkdownCodeInline", { fg = text, bg = surface })

  -- Sidekick
  hl(0, "SidekickDiffAdd", { fg = foam, bg = foam, blend = 25 })
  hl(0, "SidekickDiffContext", { fg = muted })
  hl(0, "SidekickDiffDelete", { fg = love, bg = love, blend = 25 })

  -- Snacks
  hl(0, "SnacksDashboardDesc", { fg = muted })
  hl(0, "SnacksDashboardDir", { fg = muted, italic = true })
  hl(0, "SnacksDashboardFile", { fg = text })
  hl(0, "SnacksDashboardFooter", { fg = text })
  hl(0, "SnacksDashboardSpecial", { fg = muted, italic = true })
  hl(0, "SnacksDashboardTitle", { fg = text })
  hl(0, "SnacksIndentScope", { fg = muted })

  -- Statusline
  hl(0, "StatusLine", { bg = "NONE" })
  hl(0, "StatusLineNC", { bg = "NONE" })
  hl(0, "StatusLineTerm", { link = "StatuslineTextMain" })
  hl(0, "StatuslineFilepath", { fg = muted, italic = true })
  hl(0, "StatuslineModeCommand", { fg = love, bold = true })
  hl(0, "StatuslineModeInsert", { fg = foam, bold = true })
  hl(0, "StatuslineModeNormal", { fg = pine, bold = true })
  hl(0, "StatuslineModeOther", { fg = pine, bold = true })
  hl(0, "StatuslineModeReplace", { fg = rose, bold = true })
  hl(0, "StatuslineModeVisual", { fg = iris, bold = true })
  hl(0, "StatuslineTextAccent", { fg = muted })
  hl(0, "StatuslineTextMain", { fg = gold })

  -- Base diff (matches delta rose-pine: plus=#323b47, minus=#412839)
  hl(0, "DiffAdd", { bg = 0x323b47 })
  hl(0, "DiffChange", { bg = 0x2a2837 })
  hl(0, "DiffDelete", { bg = 0x412839 })
  hl(0, "DiffText", { bg = 0x71929c })

  -- Merge diff headers
  hl(0, "MergeDiffOurs", { fg = base, bg = pine, bold = true })
  hl(0, "MergeDiffTheirs", { fg = base, bg = foam, bold = true })
  hl(0, "MergeDiffLocal", { fg = base, bg = gold, bold = true })

  -- Per-pane diff highlights (hex bg, matching delta aesthetic)
  -- OURS: pine-tinted (#31748f)
  hl(0, "MergeOursDiffAdd", { bg = 0x273647 })
  hl(0, "MergeOursDiffChange", { bg = 0x1f2d3a })
  hl(0, "MergeOursDiffText", { bg = 0x2e5468 })
  hl(0, "MergeOursDiffDelete", { bg = 0x412839 })

  -- THEIRS: foam-tinted (#9ccfd8)
  hl(0, "MergeTheirsDiffAdd", { bg = 0x253b40 })
  hl(0, "MergeTheirsDiffChange", { bg = 0x1f2f33 })
  hl(0, "MergeTheirsDiffText", { bg = 0x3a6b73 })
  hl(0, "MergeTheirsDiffDelete", { bg = 0x412839 })

  -- LOCAL: gold-tinted (#f6c177)
  hl(0, "MergeLocalDiffAdd", { bg = 0x3a3328 })
  hl(0, "MergeLocalDiffChange", { bg = 0x2e2a22 })
  hl(0, "MergeLocalDiffText", { bg = 0x5c4d2e })
  hl(0, "MergeLocalDiffDelete", { bg = 0x412839 })

  -- git-conflict inline markers (hex from delta minus/plus palette)
  hl(0, "GitConflictCurrent", { bg = 0x323b47 })
  hl(0, "GitConflictCurrentLabel", { bg = 0x3d4a59, bold = true })
  hl(0, "GitConflictIncoming", { bg = 0x253b40 })
  hl(0, "GitConflictIncomingLabel", { bg = 0x2f4b52, bold = true })
  hl(0, "GitConflictAncestor", { bg = 0x412839 })
  hl(0, "GitConflictAncestorLabel", { bg = 0x69394e, bold = true })

  -- Wilder
  hl(0, "WilderAccent", { fg = gold })
  hl(0, "WilderMauve", { fg = foam })
  hl(0, "WilderText", { fg = text })
end

return {
  "rose-pine/neovim",
  lazy = false,
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      styles = {
        transparency = true,
      },
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_custom_highlights,
    })

    local omarchy = require("treramey.omarchy")
    if omarchy.is_active() then
      local colorscheme = omarchy.get_colorscheme()
      if colorscheme then
        omarchy.apply_colorscheme(colorscheme)
        return
      end
    end
    vim.cmd("colorscheme rose-pine")
  end,
}
