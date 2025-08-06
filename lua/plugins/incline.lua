return {
	{
		"b0o/incline.nvim",
		event = "VeryLazy",
		opts = {
			hide = {
				cursorline = true,
			},
			debounce_threshold = {
				rising = 10,
				falling = 200,
			},
			window = {
				padding = 1,
				margin = { horizontal = 0, vertical = 1 },
				placement = {
					horizontal = "right",
					vertical = "top",
				},
				width = "fit",
			},
			render = function(props)
				local bufname = vim.api.nvim_buf_get_name(props.buf)
				local filename = vim.fn.fnamemodify(bufname, ":t")
				local path = vim.fn.fnamemodify(bufname, ":~:.:h")
				local palette = require("rose-pine.palette")

				if filename == "" then
					filename = "[No Name]"
				end

				local diagnostic_map = {
					[vim.diagnostic.severity.ERROR] = vim.fn.synIDattr(vim.fn.hlID("DiagnosticError"), "fg"),
					[vim.diagnostic.severity.WARN] = vim.fn.synIDattr(vim.fn.hlID("DiagnosticWarn"), "fg"),
					[vim.diagnostic.severity.INFO] = vim.fn.synIDattr(vim.fn.hlID("DiagnosticInfo"), "fg"),
					[vim.diagnostic.severity.HINT] = vim.fn.synIDattr(vim.fn.hlID("DiagnosticHint"), "fg"),
				}

				local icon, hl, _ = require("mini.icons").get("filetype", vim.bo[props.buf].filetype)
				local diagnostics = vim.diagnostic.get(props.buf)

				return {
					{ "", group = "InclineSeparator" },
					-- { path, gui = "italic", group = "InclineAccent" },
					icon
							and {
								" ",
								icon,
								" ",
								guifg = vim.fn.synIDattr(vim.fn.hlID(hl), "fg"),
								guibg = palette.overlay,
							}
						or "",
					{
						filename,
						guibg = palette.overlay,
						guifg = #diagnostics > 0 and diagnostic_map[diagnostics[1].severity] or palette.text,
					},
					vim.bo[props.buf].modified and { " ", "", " ", group = "InclineModified" } or "",
					{ "", group = "InclineSeparator" },
				}
			end,
		},
	},
}
