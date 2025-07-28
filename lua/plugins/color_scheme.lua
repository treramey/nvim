local rose_pine_config = {
	styles = {
		transparency = true,
	},
	highlight_groups = {
		MatchParen = { fg = "love", bg = "love", blend = 25 },
		CursorLineNr = { fg = "gold", bold = true },
		StatusLineTerm = { fg = "subtle", bg = "none" },
		StatuslineSeparator = { fg = "overlay", bg = "none" },
		StatuslineTextMain = { fg = "text", bg = "overlay" },
		StatuslineTextBold = { link = "StatuslineTextMain", bg = "overlay", bold = true },
		StatuslineTextAccent = { fg = "muted", bg = "overlay" },
		StatuslineSpinner = { fg = "gold", bg = "overlay" },
		StatuslineModeCommand = { fg = "love", bg = "overlay", bold = true },
		StatuslineModeInsert = { fg = "foam", bg = "overlay", bold = true },
		StatuslineModeNormal = { fg = "pine", bg = "overlay", bold = true },
		StatuslineModeOther = { fg = "pine", bg = "overlay", bold = true },
		StatuslineModeReplace = { fg = "rose", bg = "overlay", bold = true },
		StatuslineModeVisual = { fg = "iris", bg = "overlay", bold = true },
		StatuslineActiveHarpoon = { fg = "pine", bg = "overlay" },
		StatuslineSolution = { fg = "iris", bg = "overlay" },
		StatuslineLspOn = { fg = "gold", bg = "overlay" },
		StatuslineFormatterStatus = { fg = "foam", bg = "overlay" },
		StatuslineCopilot = { fg = "iris", bg = "overlay" },
		StatuslineRec = { fg = "love", bg = "overlay" },
		StatuslineScrollbar = { fg = "love", bg = "overlay" },
		StatuslineDiagnosticError = { fg = "love", bg = "overlay" },
		StatuslineDiagnosticWarn = { fg = "gold", bg = "overlay" },
		StatuslineDiagnosticInfo = { fg = "foam", bg = "overlay" },
		StatuslineDiagnosticHint = { fg = "iris", bg = "overlay" },
		QuickFixFilename = { fg = "text" },
		NoiceCmdlinePopupBorder = { fg = "rose" },
		NoiceCmdlinePopupTitle = { link = "NoiceCmdlinePopupBorder" },
		NoiceCmdlineIcon = { link = "NoiceCmdlinePopupBorder" },
		NoiceMini = { fg = "muted" },
		CodeCompanionChatHeader = { fg = "rose" },
		CodeCompanionChatSeparator = { fg = "muted" },
		CodeCompanionChatTokens = { fg = "gold" },
		CodeCompanionChatTool = { fg = "pine" },
		CodeCompanionChatVariable = { fg = "base", bg = "iris" },
		CodeCompanionVirtualText = { fg = "iris" },
		DapUIStepOver = { fg = "foam" },
		DapUIStepInto = { fg = "foam" },
		DapUIStepBack = { fg = "foam" },
		DapUIStepOut = { fg = "foam" },
		DapUIStop = { fg = "love" },
		DapUIPlayPause = { fg = "pine" },
		DapUIRestart = { fg = "pine" },
		DapUIUnavailable = { fg = "muted" },
		IndentLineCurrent = { fg = "muted" },
		EasyDotnetTestRunnerSolution = { fg = "pine" },
		EasyDotnetTestRunnerProject = { fg = "rose" },
		EasyDotnetTestRunnerTest = { fg = "iris" },
		SnacksIndentScope = { fg = "gold" },
		SnacksDashboardSpecial = { fg = "gold" },

		BlinkCmpSource = { fg = "text", bg = "base" },

		CmpPmenu = { fg = "text", bg = "surface" },
		CmpPmenuSel = { fg = "base", bg = "overlay" },
		CmpPmenuBorder = { fg = "surface", bg = "surface" },
		CmpPmenuSbar = { bg = "muted" },
		CmpPmenuThumb = { bg = "subtle" },

		CmpItemAbbr = { fg = "text" },
		CmpItemAbbrMatch = { fg = "iris", bold = true },
		CmpItemKind = { fg = "foam" },
		CmpItemKindFunction = { fg = "text" },
		CmpItemKindMethod = { fg = "text" },
		CmpItemKindVariable = { fg = "gold" },
		CmpItemKindKeyword = { fg = "iris" },
		CmpItemKindSnippet = { fg = "text" },
		CmpItemKindProperty = { fg = "iris" },
		CmpItemKindField = { fg = "gold" },
		CmpItemKindEnum = { fg = "pine" },
		CmpItemKindInterface = { fg = "foam" },
		CmpItemKindText = { fg = "text" },
		CmpItemKindClass = { fg = "pine" },
		CmpItemMenu = { fg = "muted" },

		CmpDoc = { fg = "text", bg = "base" },
		CmpDocBorder = { fg = "base", bg = "base" },

		-- Wilder highlight groups
		WilderText = { fg = "text", bg = "base" },
		WilderMauve = { fg = "muted", bg = "base" },

		MiniIconsAzureBlend = { fg = "foam", bg = "foam", blend = 25 },
		MiniIconsBlueBlend = { fg = "pine", bg = "pine", blend = 25 },
		MiniIconsCyanBlend = { fg = "foam", bg = "foam", blend = 25 },
		MiniIconsGreenBlend = { fg = "leaf", bg = "leaf", blend = 25 },
		MiniIconsGreyBlend = { fg = "subtle", bg = "subtle", blend = 25 },
		MiniIconsOrangeBlend = { fg = "rose", bg = "rose", blend = 25 },
		MiniIconsPurpleBlend = { fg = "iris", bg = "iris", blend = 25 },
		MiniIconsRedBlend = { fg = "love", bg = "love", blend = 25 },
		MiniIconsYellowBlend = { fg = "gold", bg = "gold", blend = 25 },

		-- Fidget highlight groups
		FidgetTask = { fg = "text", bg = "none" },
		FidgetTitle = { fg = "gold", bg = "none", bold = true },
		FidgetProgress = { fg = "pine", bg = "none" },
		FidgetProgressDone = { fg = "foam", bg = "none" },
		FidgetProgressOngoing = { fg = "gold", bg = "none" },
		FidgetProgressBlank = { fg = "muted", bg = "none" },
		FidgetNotificationGroup = { fg = "rose", bg = "none", bold = true },
		FidgetNotificationTitle = { fg = "text", bg = "none" },
		FidgetNotificationIcon = { fg = "iris", bg = "none" },
		FidgetNotificationWindow = { fg = "text", bg = "base" },
		FidgetNotificationBorder = { fg = "overlay", bg = "none" },

		-- Incline highlight groups
		InclineAccent = { fg = "muted", bg = "overlay" },
		InclineSeparator = { fg = "overlay", bg = "NONE" },
		InclineModified = { fg = "gold", bg = "overlay" },
	},
}

local function setup_rose_pine(variant)
	local config = vim.tbl_deep_extend("force", rose_pine_config, { variant = variant })
	require("rose-pine").setup(config)
	vim.cmd("colorscheme rose-pine")
end

return {
	{
		"rose-pine/neovim",
		lazy = false,
		name = "rose-pine",
		config = function()
			setup_rose_pine("main")
		end,
	},
	{
		"cormacrelf/dark-notify",
		lazy = false,
		config = function()
			require("dark_notify").run({
				onchange = function(mode)
					local variant = mode == "dark" and "main" or "dawn"
					setup_rose_pine(variant)

					-- Refresh all UI elements after colorscheme change
					vim.cmd("redrawstatus")
					vim.cmd("redraw")
					vim.cmd("doautocmd ColorScheme")
				end,
			})
		end,
	},
}
