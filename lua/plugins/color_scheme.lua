return {
	{
		"catppuccin/nvim",
		config = function()
			local transparent = true

			require("catppuccin").setup({
				flavour = transparent and "mocha" or "macchiato",
				transparent_background = transparent,
				styles = {
					keywords = { "bold" },
					functions = { "italic" },
				},
				integrations = {
					cmp = true,
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
					telescope = { style = transparent and nil or "nvchad" },
					treesitter = true,
					treesitter_context = false,
				},
				custom_highlights = function(colors)
					return {
						-- custom
						PanelHeading = {
							fg = colors.lavender,
							bg = transparent and colors.none or colors.crust,
							style = { "bold", "italic" },
						},

						-- treesitter-context
						TreesitterContextLineNumber = transparent and {
							fg = colors.rosewater,
						} or { fg = colors.subtext0, bg = colors.mantle },

						-- lazy.nvim
						LazyH1 = {
							bg = transparent and colors.none or colors.peach,
							fg = transparent and colors.lavender or colors.base,
							style = { "bold" },
						},
						LazyButton = {
							bg = colors.none,
							fg = transparent and colors.overlay0 or colors.subtext0,
						},
						LazyButtonActive = {
							bg = transparent and colors.none or colors.overlay1,
							fg = transparent and colors.lavender or colors.base,
							style = { "bold" },
						},
						LazySpecial = { fg = colors.green },

						CmpItemMenu = { fg = colors.subtext1 },
						MiniIndentscopeSymbol = { fg = colors.overlay0 },

						FloatBorder = {
							fg = transparent and colors.blue or colors.mantle,
							bg = transparent and colors.none or colors.mantle,
						},

						FloatTitle = {
							fg = transparent and colors.lavender or colors.base,
							bg = transparent and colors.none or colors.lavender,
						},
					}
				end,
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
