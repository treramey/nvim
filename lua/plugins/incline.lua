return {
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
				local palette = require("catppuccin.palettes").get_palette("macchiato")
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
					guibg = palette.overlay0,
					{ "", guifg = palette.overlay0, guibg = palette.base },
					vim.bo[props.buf].modified and { " ", "", guifg = palette.yellow } or "",
					icon and { " ", icon, " ", guifg = vim.fn.synIDattr(vim.fn.hlID(hl), "fg") } or "",
					{ filename, guifg = #diagnostics > 0 and diagnostic_map[diagnostics[1].severity] or "" },
					" ",
					{ path, " ", gui = "italic", guifg = palette.subtext0 },
					{ "", guifg = palette.overlay0, guibg = palette.base },
				}
			end,
		},
		-- Optional: Lazy load Incline
		event = "VeryLazy",
	},
}
