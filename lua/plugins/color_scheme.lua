return {
	{
		"rose-pine/neovim",
		lazy = false,
		name = "rose-pine",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("rose-pine").setup({
				styles = {
					transparency = true,
				},
				highlight_groups = {
					EndOfBuffer = { fg = "base" },
					MatchParen = { fg = "love", bg = "love", blend = 25 },
					CursorLineNr = { fg = "gold", bold = true },
					StatusLine = { bg = "overlay" },
					StatusLineTerm = { fg = "subtle", bg = "overlay" },
					StatuslineSeparator = { fg = "base", bg = "overlay" },
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
					SnacksIndentScope = { fg = "overlay" },
					SnacksDashboardSpecial = { fg = "gold" },

					BlinkCmpSource = { fg = "text", bg = "base" },

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
				},
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	priority = 10000,
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			flavour = "mocha",
	-- 			styles = {
	-- 				keywords = { "bold" },
	-- 				functions = { "italic" },
	-- 			},
	-- 			integrations = {
	-- 				fidget = true,
	-- 				gitsigns = true,
	-- 				grug_far = true,
	-- 				harpoon = true,
	-- 				indent_blankline = {
	-- 					enabled = false,
	-- 					scope_color = "sapphire",
	-- 					colored_indent_levels = false,
	-- 				},
	-- 				mason = true,
	-- 				native_lsp = { enabled = true },
	-- 				noice = true,
	-- 				notify = true,
	-- 				render_markdown = true,
	-- 				symbols_outline = true,
	-- 				snacks = {
	-- 					enabled = true,
	-- 					indent_scope_color = "mauve",
	-- 				},
	-- 				telescope = { enabled = true },
	-- 				treesitter = true,
	-- 				treesitter_context = true,
	-- 			},
	-- 			custom_highlights = function(colors)
	-- 				return {
	-- 					-- custom
	-- 					BlinkCmpMenu = { bg = colors.base },
	-- 					BlinkCmpDoc = { bg = colors.base },
	-- 					BlinkCmpDocSeparator = { bg = colors.base },
	-- 					BlinkCmpSignatureHelp = { bg = colors.base },
	-- 					BlinkCmpMenuBorder = { link = "FloatBorder" },
	-- 					BlinkCmpDocBorder = { link = "FloatBorder" },
	-- 					BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
	-- 					BlinkCmpSource = { fg = colors.overlay0 },
	-- 					BlinkCmpKind = { fg = colors.overlay0 },
	--
	-- 					DiagnosticError = { bg = colors.base },
	-- 					DiagnosticWarn = { bg = colors.base },
	-- 					DiagnosticInfo = { bg = colors.base },
	-- 					DiagnosticHint = { bg = colors.base },
	-- 					StatuslineDiagnosticError = { fg = colors.red, bg = colors.base },
	-- 					StatuslineDiagnosticWarn = { fg = colors.yellow, bg = colors.base },
	-- 					StatuslineDiagnosticInfo = { fg = colors.sapphire, bg = colors.base },
	-- 					StatuslineDiagnosticHint = { fg = colors.teal, bg = colors.base },
	--
	-- 					StatusLine = { bg = colors.base },
	-- 					StatusLineTerm = { fg = colors.text, bg = "none" },
	-- 					StatuslineSeparator = { fg = colors.base, bg = "none" },
	-- 					StatuslineTextMain = { fg = colors.text, bg = colors.base },
	-- 					StatuslineTextBold = { link = "StatuslineTextMain", bg = colors.base, bold = true },
	-- 					StatuslineTextAccent = { fg = colors.overlay2, bg = colors.base },
	-- 					StatuslineModeCommand = { link = "StatuslineTextMain", bold = true },
	-- 					StatuslineSpinner = { fg = colors.yellow, bg = colors.base },
	-- 					StatuslineModeInsert = { fg = colors.sky, bg = colors.base, bold = true },
	-- 					StatuslineModeNormal = { fg = colors.lavender, bg = colors.base, bold = true },
	-- 					StatuslineModeOther = { fg = colors.lavender, bg = colors.base, bold = true },
	-- 					StatuslineModeReplace = { fg = colors.sapphire, bg = colors.base, bold = true },
	-- 					StatuslineModeVisual = { fg = colors.flamingo, bg = colors.base, bold = true },
	-- 					StatuslineNotSaved = { fg = colors.yellow, bg = colors.base },
	-- 					StatuslineReadOnly = { fg = colors.red, bg = colors.base },
	-- 					StatuslineLspOn = { fg = colors.sapphire, bg = colors.base },
	-- 					StatuslineFormatterStatus = { fg = colors.teal, bg = colors.base },
	-- 					StatuslineCopilot = { fg = colors.pink, bg = colors.base },
	-- 					StatuslineActiveHarpoon = { fg = colors.mauve, bg = colors.base },
	-- 					StatuslineScrollbar = { fg = colors.flamingo, bg = colors.base },
	-- 					CodeCompanionChatHeader = { fg = colors.lavender },
	-- 					CodeCompanionChatSeparator = { fg = colors.overlay0 },
	-- 					CodeCompanionChatTokens = { fg = colors.yellow },
	-- 					CodeCompanionChatTool = { fg = colors.sapphire },
	-- 					CodeCompanionChatVariable = { fg = colors.base, bg = colors.mauve },
	-- 					CodeCompanionVirtualText = { fg = colors.mauve },
	-- 					SnacksPicker = { bg = colors.base, fg = colors.text },
	-- 					MiniIconsBlue = { bg = colors.base, fg = colors.lavender },
	--
	-- 					SnacksPickerBoxBorder = { fg = colors.blue },
	-- 					SnacksPickerInputBorder = { fg = colors.blue },
	-- 					SnacksPickerTitle = { fg = colors.blue },
	-- 					SnacksInputIcon = { fg = colors.mauve },
	-- 					SnacksInputNormal = { bg = colors.base, fg = colors.text },
	-- 					SnacksInputBorder = { fg = colors.blue },
	-- 					SnacksInputTitle = { fg = colors.blue },
	--
	-- 					-- C# type highlighting
	-- 					-- ["@type.qualifier.c_sharp"] = { fg = colors.blue }, -- For namespaces and type qualifiers
	-- 					-- ["@type.c_sharp"] = { fg = colors.rosewater }, -- For regular types
	-- 					-- ["@constructor.c_sharp"] = { fg = colors.peach }, -- For constructors
	-- 					-- ["@lsp.type.interface.c_sharp"] = { fg = colors.sky }, -- For interfaces (like IEnumerable)
	-- 					-- ["@lsp.type.class.c_sharp"] = { fg = colors.green }, -- For classes
	-- 					-- ["@lsp.type.enum.c_sharp"] = { fg = colors.mauve }, -- For enums
	-- 					-- ["@lsp.type.typeParameter.c_sharp"] = { fg = colors.lavender }, -- For type parameters in generics
	-- 					-- ["@punctuation.bracket.c_sharp"] = { fg = colors.overlay2 }, -- For angle brackets < >
	--
	-- 					-- Special case for generic type containers
	-- 					-- CSharpGenericContainer = { fg = colors.lavender, italic = true }, -- Special styling for generic containers
	-- 				}
	-- 			end,
	-- 		})
	--
	-- 		vim.cmd.colorscheme("catppuccin-macchiato")
	-- 		-- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
	-- 		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	-- 			vim.api.nvim_set_hl(0, group, {})
	-- 		end
	-- 	end,
	-- },
}
