return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			default_format_opts = {
				async = true,
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			format_after_save = {
				async = true,
				timeout_ms = 500,
				lsp_format = "fallback",
				stop_after_first = true,
			},
			formatters_by_ft = {
				astro = { "prettierd", "prettier" },
				cs = { "csharpier" },
				go = { "gofmt", "goimports" },
				gohtml = { "goimports" },
				javascript = { "biome" },
				lua = { "stylua" },
				svelte = { "prettierd", "prettier" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
				yaml = { "yamlfmt" },
			},
			formatters = {
				csharpier = {
					command = "dotnet-csharpier",
					args = { "--write-stdout", "--no-cache", "$FILENAME" },
				},
			},
		},
	},
}
