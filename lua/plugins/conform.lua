return {
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
		},
		formatters_by_ft = {
			cs = { "csharpier" },
			css = { "prettier" },
			go = { "gofmt" },
			html = { "prettier", "rustywind" },
			json = { "prettier" },
			jsonc = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			mdx = { "prettier" },
			svg = { "xmlformat" },
			javascript = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome", "rustywind" },
			svelte = { "prettier", "rustywind" },
			xml = { "xmlformat" },
			yaml = { "prettier" },
		},
		formatters = {
			xmlformat = {
				cmd = { "xmlformat" },
				args = { "--selfclose", "-" },
			},
			injected = { options = { ignore_errors = false } },
		},
	},
}
