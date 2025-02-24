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
					symbols_outline = true,
					telescope = true,
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
						StatuslineLspOn = { fg = colors.subtext0 },
						StatuslineFormatterStatus = { fg = colors.subtext0 },
						StatuslineCopilot = { fg = colors.subtext0 },
						StatuslineActiveHarpoon = { fg = colors.rosewater },
						CodeCompanionChatHeader = { fg = colors.lavender },
						CodeCompanionChatSeparator = { fg = colors.overlay0 },
						CodeCompanionChatTokens = { fg = colors.yellow },
						CodeCompanionChatTool = { fg = colors.sapphire },
						CodeCompanionChatVariable = { fg = colors.base, bg = colors.mauve },
						CodeCompanionVirtualText = { fg = colors.mauve },
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
