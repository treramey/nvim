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
			python = { "isort", "black" },
			javascript = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			svelte = { "prettierd", "prettier" },
			xml = { "csharpier" },
			yaml = { "prettier" },
		},
		format_after_save = function(buffer_number)
			local filetype = vim.bo[buffer_number].filetype

			if
				vim.g.disable_autoformat
				or vim.b[buffer_number].disable_autoformat
				or vim.tbl_contains(vim.g.disable_autoformat_filetypes or {}, filetype)
			then
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
