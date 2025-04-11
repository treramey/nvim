return {
	{
		"catppuccin/nvim",
		priority = 10000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				styles = {
					keywords = { "bold" },
					functions = { "italic" },
				},
				integrations = {
					blink_cmp = true,
					fidget = true,
					gitsigns = true,
					grug_far = true,
					harpoon = true,
					indent_blankline = {
						enabled = false,
						scope_color = "sapphire",
						colored_indent_levels = false,
					},
					mason = true,
					native_lsp = { enabled = true },
					noice = true,
					notify = true,
					render_markdown = true,
					symbols_outline = true,
					snacks = {
						enabled = true,
						indent_scope_color = "mauve",
					},
					telescope = { enabled = true },
					treesitter = true,
					treesitter_context = true,
				},
				custom_highlights = function(colors)
					return {
						-- custom
						BlinkCmpMenu = { fg = colors.overlay2 },
						BlinkCmpMenuBorder = { fg = colors.blue },
						BlinkCmpDocBorder = { fg = colors.blue },
						BlinkCmpSignatureHelpActiveParameter = { fg = colors.mauve },
						DiagnostcError = { bg = colors.mantle },
						DiagnosticWarn = { bg = colors.mantle },
						DiagnosticInfo = { bg = colors.mantle },
						DiagnosticHint = { bg = colors.mantle },
						StatusLine = { bg = colors.base },
						StatusLineTerm = { fg = colors.text, bg = "none" },
						StatuslineSeparator = { fg = colors.mantle, bg = "none" },
						StatuslineTextMain = { fg = colors.text, bg = colors.mantle },
						StatuslineTextBold = { link = "StatuslineTextMain", bg = colors.mantle, bold = true },
						StatuslineTextAccent = { fg = colors.overlay0, bg = colors.mantle },
						StatuslineModeCommand = { link = "StatuslineTextMain", bold = true },
						StatuslineModeInsert = { fg = colors.sky, bg = colors.mantle, bold = true },
						StatuslineModeNormal = { fg = colors.lavender, bg = colors.mantle, bold = true },
						StatuslineModeOther = { fg = colors.lavender, bg = colors.mantle, bold = true },
						StatuslineModeReplace = { fg = colors.sapphire, bg = colors.mantle, bold = true },
						StatuslineModeVisual = { fg = colors.mauve, bg = colors.mantle, bold = true },
						StatuslineNotSaved = { fg = colors.yellow, bg = colors.mantle },
						StatuslineReadOnly = { fg = colors.red, bg = colors.mantle },
						StatuslineLspOn = { fg = colors.sky, bg = colors.mantle },
						StatuslineFormatterStatus = { fg = colors.sky, bg = colors.mantle },
						StatuslineCopilot = { fg = colors.sky, bg = colors.mantle },
						StatuslineActiveHarpoon = { fg = colors.mauve, bg = colors.mantle },
						StatuslineScrollbar = { fg = colors.flamingo, bg = colors.mantle },
						StatuslineDiagnosticError = { fg = colors.red, bg = colors.mantle },
						StatuslineDiagnosticWarn = { fg = colors.yellow, bg = colors.mantle },
						StatuslineDiagnosticInfo = { fg = colors.sky, bg = colors.mantle },
						StatuslineDiagnosticHint = { fg = colors.flamingo, bg = colors.mantle },
						CodeCompanionChatHeader = { fg = colors.lavender },
						CodeCompanionChatSeparator = { fg = colors.overlay0 },
						CodeCompanionChatTokens = { fg = colors.yellow },
						CodeCompanionChatTool = { fg = colors.sapphire },
						CodeCompanionChatVariable = { fg = colors.base, bg = colors.mauve },
						CodeCompanionVirtualText = { fg = colors.mauve },
						SnacksPicker = { bg = colors.base, fg = colors.text },
						MiniIconsBlue = { bg = colors.mantle, fg = colors.lavender },
						SnacksPickerBoxBorder = {
							fg = colors.mauve,
						},
						SnacksPickerInputBorder = {
							fg = colors.mauve,
						},
						SnacksPickerTitle = { fg = colors.mauve },

						-- C# type highlighting
						-- ["@type.qualifier.c_sharp"] = { fg = colors.blue }, -- For namespaces and type qualifiers
						["@type.c_sharp"] = { fg = colors.rosewater }, -- For regular types
						-- ["@constructor.c_sharp"] = { fg = colors.peach }, -- For constructors
						-- ["@lsp.type.interface.c_sharp"] = { fg = colors.sky }, -- For interfaces (like IEnumerable)
						-- ["@lsp.type.class.c_sharp"] = { fg = colors.green }, -- For classes
						-- ["@lsp.type.enum.c_sharp"] = { fg = colors.mauve }, -- For enums
						-- ["@lsp.type.typeParameter.c_sharp"] = { fg = colors.lavender }, -- For type parameters in generics
						-- ["@punctuation.bracket.c_sharp"] = { fg = colors.overlay2 }, -- For angle brackets < >

						-- Special case for generic type containers
						CSharpGenericContainer = { fg = colors.lavender, italic = true }, -- Special styling for generic containers
					}
				end,
			})

			vim.cmd.colorscheme("catppuccin-macchiato")
			-- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
			for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
				vim.api.nvim_set_hl(0, group, {})
			end
		end,
	},
}
