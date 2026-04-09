-- Generic highlight groups that adapt to any colorscheme.
-- Extracts semantic colors from standard highlight groups and applies
-- custom highlights for statusline, diff, git, oil, snacks, etc.
local M = {}

local function get_hl_fg(name)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if ok and hl.fg then
		return string.format("#%06x", hl.fg)
	end
	return nil
end

local function get_hl_bg(name)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if ok and hl.bg then
		return string.format("#%06x", hl.bg)
	end
	return nil
end

local function blend_hex(hex, bg_hex, alpha)
	if not hex or not bg_hex then
		return nil
	end
	local r1, g1, b1 = hex:match("#(%x%x)(%x%x)(%x%x)")
	local r2, g2, b2 = bg_hex:match("#(%x%x)(%x%x)(%x%x)")
	if not r1 or not r2 then
		return nil
	end
	r1, g1, b1 = tonumber(r1, 16), tonumber(g1, 16), tonumber(b1, 16)
	r2, g2, b2 = tonumber(r2, 16), tonumber(g2, 16), tonumber(b2, 16)
	local r = math.floor(r1 * alpha + r2 * (1 - alpha))
	local g = math.floor(g1 * alpha + g2 * (1 - alpha))
	local b = math.floor(b1 * alpha + b2 * (1 - alpha))
	return string.format("#%02x%02x%02x", r, g, b)
end

function M.get_palette()
	return {
		text = get_hl_fg("Normal") or "#e0def4",
		muted = get_hl_fg("NonText") or "#6e6a86",
		subtle = get_hl_fg("Comment") or "#908caa",
		love = get_hl_fg("DiagnosticError") or "#eb6f92",
		gold = get_hl_fg("Constant") or "#f6c177",
		foam = get_hl_fg("Type") or "#9ccfd8",
		pine = get_hl_fg("Statement") or "#31748f",
		iris = get_hl_fg("PreProc") or "#c4a7e7",
		rose = get_hl_fg("Function") or "#ebbcba",
		base = get_hl_bg("Normal") or (vim.o.background == "light" and "#faf4ed" or "#191724"),
		surface = get_hl_bg("CursorLine") or "#1f1d2e",
		overlay = get_hl_bg("Pmenu") or "#26233a",
	}
end

function M.apply()
	local p = M.get_palette()
	local bg = p.base

	-- Blended backgrounds for diff/conflict (25% color over base)
	local diff_add_bg = blend_hex(p.foam, bg, 0.15)
	local diff_del_bg = blend_hex(p.love, bg, 0.15)
	local diff_chg_bg = blend_hex(p.iris, bg, 0.10)
	local diff_txt_bg = blend_hex(p.foam, bg, 0.30)

	-- Pine-tinted (ours)
	local ours_add = blend_hex(p.pine, bg, 0.15)
	local ours_chg = blend_hex(p.pine, bg, 0.10)
	local ours_txt = blend_hex(p.pine, bg, 0.25)

	-- Foam-tinted (theirs)
	local theirs_add = blend_hex(p.foam, bg, 0.15)
	local theirs_chg = blend_hex(p.foam, bg, 0.10)
	local theirs_txt = blend_hex(p.foam, bg, 0.25)

	-- Gold-tinted (local)
	local local_add = blend_hex(p.gold, bg, 0.15)
	local local_chg = blend_hex(p.gold, bg, 0.10)
	local local_txt = blend_hex(p.gold, bg, 0.25)

	-- Conflict backgrounds
	local conflict_cur = diff_add_bg
	local conflict_cur_label = blend_hex(p.pine, bg, 0.20)
	local conflict_inc = theirs_add
	local conflict_inc_label = blend_hex(p.foam, bg, 0.20)
	local conflict_anc = diff_del_bg
	local conflict_anc_label = blend_hex(p.love, bg, 0.20)

	local highlights = {
		IndentLineCurrent = { fg = p.muted },
		MatchParen = { fg = p.love, bg = blend_hex(p.love, bg, 0.25) },
		QuickFixFilename = { fg = p.text },

		-- Dart (harpoon-like)
		DartCurrentLabel = { fg = p.gold, bg = p.overlay, bold = true },
		DartCurrentLabelModified = { fg = p.gold, bg = p.overlay, bold = true },
		DartCurrentModified = { fg = p.text, bg = p.overlay, bold = true },
		DartMarkedCurrentLabel = { fg = p.gold, bg = p.overlay, bold = true },
		DartMarkedCurrentLabelModified = { fg = p.gold, bg = p.overlay, bold = true },
		DartMarkedCurrentModified = { fg = p.text, bg = p.overlay, bold = true },
		DartMarkedLabel = { fg = p.gold, bg = p.surface, bold = true },
		DartMarkedLabelModified = { fg = p.gold, bg = p.text, bold = true },
		DartPickLabel = { fg = p.gold, bold = true },
		DartVisibleLabel = { fg = p.gold, bg = p.surface, bold = true },
		DartVisibleLabelModified = { fg = p.gold, bg = p.text, bold = true },

		-- EasyDotnet
		EasyDotnetDebuggerFloatVariable = { fg = p.text, bg = p.overlay },
		EasyDotnetDebuggerVirtualException = { fg = p.love, italic = true },
		EasyDotnetDebuggerVirtualVariable = { fg = p.iris, italic = true },
		EasyDotnetTestRunnerProject = { fg = p.rose },
		EasyDotnetTestRunnerSolution = { fg = p.pine },
		EasyDotnetTestRunnerTest = { fg = p.iris },

		-- Oil
		OilGitAdded = { fg = p.foam },
		OilGitModified = { fg = p.rose },
		OilGitRenamed = { fg = p.pine },
		OilGitUntracked = { fg = p.subtle },
		OilGitIgnored = { fg = p.muted },

		-- Render Markdown
		RenderMarkdownCode = { bg = p.overlay },
		RenderMarkdownCodeInline = { fg = p.text, bg = p.surface },

		-- Sidekick
		SidekickDiffAdd = { fg = p.foam, bg = blend_hex(p.foam, bg, 0.25) },
		SidekickDiffContext = { fg = p.muted },
		SidekickDiffDelete = { fg = p.love, bg = blend_hex(p.love, bg, 0.25) },

		-- Snacks
		SnacksDashboardDesc = { fg = p.muted },
		SnacksDashboardDir = { fg = p.muted, italic = true },
		SnacksDashboardFile = { fg = p.text },
		SnacksDashboardFooter = { fg = p.text },
		SnacksDashboardSpecial = { fg = p.muted, italic = true },
		SnacksDashboardTitle = { fg = p.text },
		SnacksIndentScope = { fg = p.muted },

		-- Statusline
		StatusLineTerm = { link = "StatuslineTextMain" },
		StatuslineFilepath = { fg = p.muted, italic = true },
		StatuslineModeCommand = { fg = p.love, bold = true },
		StatuslineModeInsert = { fg = p.foam, bold = true },
		StatuslineModeNormal = { fg = p.pine, bold = true },
		StatuslineModeOther = { fg = p.pine, bold = true },
		StatuslineModeReplace = { fg = p.rose, bold = true },
		StatuslineModeVisual = { fg = p.iris, bold = true },
		StatuslineTextAccent = { fg = p.muted },
		StatuslineTextMain = { fg = p.text },

		-- Diff
		DiffAdd = { bg = diff_add_bg },
		DiffChange = { bg = diff_chg_bg },
		DiffDelete = { bg = diff_del_bg },
		DiffText = { bg = diff_txt_bg },

		-- Merge labels
		MergeDiffOurs = { fg = p.base, bg = p.pine, bold = true },
		MergeDiffTheirs = { fg = p.base, bg = p.foam, bold = true },
		MergeDiffLocal = { fg = p.base, bg = p.gold, bold = true },

		-- Merge per-pane (ours)
		MergeOursDiffAdd = { bg = ours_add },
		MergeOursDiffChange = { bg = ours_chg },
		MergeOursDiffText = { bg = ours_txt },
		MergeOursDiffDelete = { bg = diff_del_bg },

		-- Merge per-pane (theirs)
		MergeTheirsDiffAdd = { bg = theirs_add },
		MergeTheirsDiffChange = { bg = theirs_chg },
		MergeTheirsDiffText = { bg = theirs_txt },
		MergeTheirsDiffDelete = { bg = diff_del_bg },

		-- Merge per-pane (local)
		MergeLocalDiffAdd = { bg = local_add },
		MergeLocalDiffChange = { bg = local_chg },
		MergeLocalDiffText = { bg = local_txt },
		MergeLocalDiffDelete = { bg = diff_del_bg },

		-- Git conflict
		GitConflictCurrent = { bg = conflict_cur },
		GitConflictCurrentLabel = { bg = conflict_cur_label, bold = true },
		GitConflictIncoming = { bg = conflict_inc },
		GitConflictIncomingLabel = { bg = conflict_inc_label, bold = true },
		GitConflictAncestor = { bg = conflict_anc },
		GitConflictAncestorLabel = { bg = conflict_anc_label, bold = true },

		-- Wilder
		WilderAccent = { fg = p.gold },
		WilderMauve = { fg = p.foam },
		WilderText = { fg = p.text },
	}

	for name, hl in pairs(highlights) do
		vim.api.nvim_set_hl(0, name, hl)
	end
end

return M
