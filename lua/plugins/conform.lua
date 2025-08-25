return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			cs = { "csharpier" },
			json = { "biome" },
			lua = { "stylua" },
			markdown = { "prettier" },
			javascript = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			svelte = { "prettierd", "prettier" },
			xml = { "csharpier" },
			yaml = { "prettier" },
		},
		format_after_save = function(buffer_number)
			if vim.g.disable_autoformat or vim.b[buffer_number].disable_autoformat then
				return
			end
			return {
				async = true,
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,
	},
}
