return {
	{
		"catppuccin/nvim",
		priority = 10000,
		lazy = false,
		config = function()
			local transparent = false

			require("catppuccin").setup({
				flavour = transparent and "mocha" or "macchiato",
				transparent_background = transparent,
				styles = {
					keywords = { "bold" },
					functions = { "italic" },
				},
				integrations = {
					cmp = true,
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
						enabled = false,
						indent_scope_color = "mauve",
					},
					telescope = { enabled = true },
					treesitter = true,
					treesitter_context = true,
				},
				custom_highlights = function(colors)
					return {
						-- custom
						StatuslineTextMain = { fg = colors.text },
						StatuslineTextBold = { link = "StatuslineTextMain", bold = true },
						StatuslineTextAccent = { fg = colors.overlay0 },
						StatuslineModeCommand = { link = "StatuslineTextMain", bold = true },
						StatuslineModeInsert = { fg = colors.sky, bold = true },
						StatuslineModeNormal = { fg = colors.lavender, bold = true },
						StatuslineModeOther = { fg = colors.lavender, bold = true },
						StatuslineModeReplace = { fg = colors.sapphire, bold = true },
						StatuslineModeVisual = { fg = colors.mauve, bold = true },
						StatuslineNotSaved = { fg = colors.yellow },
						StatuslineReadOnly = { fg = colors.red },
						StatuslineLspOn = { fg = colors.flamingo },
						StatuslineFormatterStatus = { fg = colors.flamingo },
						StatuslineCopilot = { fg = colors.flamingo },
						StatuslineActiveHarpoon = { fg = colors.lavender },
						CodeCompanionChatHeader = { fg = colors.lavender },
						CodeCompanionChatSeparator = { fg = colors.overlay0 },
						CodeCompanionChatTokens = { fg = colors.yellow },
						CodeCompanionChatTool = { fg = colors.sapphire },
						CodeCompanionChatVariable = { fg = colors.base, bg = colors.mauve },
						CodeCompanionVirtualText = { fg = colors.mauve },
						SnacksPicker = { bg = colors.base, fg = colors.text },
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
