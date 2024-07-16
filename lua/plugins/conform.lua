return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			format_after_save = {
				async = true,
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				cs = { "csharpier" },
				yaml = { { "yamlfmt" } },
				javascript = { { "prettierd", "prettier", "biome" } },
				typescript = { { "prettierd", "prettier", "biome" } },
				typescriptreact = { { "prettierd", "prettier", "biome" } },
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
				gohtml = { "goimports" },
			},
			formatters = {
				csharpier = {
					command = "dotnet-csharpier",
					args = { "--write-stdout" },
				},
			},
		},
	},
}
