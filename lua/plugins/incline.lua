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
	{
		"b0o/incline.nvim",
		opts = {
			debounce_threshold = {
				rising = 10,
				falling = 1000,
			},
			window = {
				padding = 1,
				margin = { horizontal = 0 },
			},
			render = function(props)
				local palette = require("rose-pine.palette")
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				local path = vim.fn.expand("%:~:.:h")
				if filename == "" then
					filename = "[No Name]"
				end

				local diagnostic_map = {
					[vim.diagnostic.severity.ERROR] = vim.fn.synIDattr(vim.fn.hlID("DiagnosticError"), "fg"),
					[vim.diagnostic.severity.WARN] = vim.fn.synIDattr(vim.fn.hlID("DiagnosticWarn"), "fg"),
					[vim.diagnostic.severity.INFO] = vim.fn.synIDattr(vim.fn.hlID("DiagnosticInfo"), "fg"),
					[vim.diagnostic.severity.HINT] = vim.fn.synIDattr(vim.fn.hlID("DiagnosticHint"), "fg"),
				}
				local icon, hl, _ = require("mini.icons").get("filetype", vim.bo.filetype)
				local diagnostics = vim.diagnostic.get(props.buf)
				return {
					guibg = palette.overlay,
					{ "", guifg = palette.overlay, guibg = palette.base },
					{ path, gui = "italic", guifg = palette.muted },
					icon and { " ", icon, " ", guifg = vim.fn.synIDattr(vim.fn.hlID(hl), "fg") } or "",
					{ filename, guifg = #diagnostics > 0 and diagnostic_map[diagnostics[1].severity] or "" },
					vim.bo[props.buf].modified and { " ", "", guifg = palette.gold } or "",
					" ",
					{ "", guifg = palette.overlay, guibg = palette.base },
				}
			end,
		},
		-- Optional: Lazy load Incline
		event = "VeryLazy",
	},
}
