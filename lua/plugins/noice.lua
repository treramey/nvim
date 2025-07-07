return {
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
		opts = {
			cmdline = {
				view = "cmdline",
				enabled = false,
				format = {
					cmdline = { pattern = "^:", icon = "❯", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "󰆍", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "󰢱", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
					input = { view = "cmdline_input", icon = "󰭎" },
				},
			},
			messages = {
				enabled = false,
			},
			popupmenu = {
				enabled = false,
			},
			lsp = {
				progress = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			notify = { enabled = false },
			presets = {
				bottom_search = true,
				long_message_to_split = true,
				inc_rename = true,
			},
			views = {
				mini = {
					position = {
						col = -2,
						row = -2,
					},
					win_options = {
						winblend = 0,
					},
					border = {
						style = "single",
					},
				},
				cmdline_input = {
					border = {
						style = "single",
					},
				},
				cmdline_popup = {
					border = {
						style = "single",
					},
				},
			},
		},
	},
}
