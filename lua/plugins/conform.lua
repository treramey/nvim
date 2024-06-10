return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			format_on_save = {
				-- I recommend these options. See :help conform.format for details.
				lsp_fallback = true,
				timeout_ms = 500,
			},
			-- If this is set, Conform will run the formatter asynchronously after save.
			-- It will pass the table to conform.format().
			-- This can also be a function that returns the table.
			format_after_save = {
				async = true,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				javascript = { { "prettierd", "prettier", "biome" } },
				typescript = { { "prettierd", "prettier", "biome" } },
				typescriptreact = { { "prettierd", "prettier", "biome" } },
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
				gohtml = { "goimports" },
			},
		},
	},
}
