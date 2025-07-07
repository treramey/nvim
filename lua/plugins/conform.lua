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
		format_after_save = function(bufnr)
			local ft = vim.bo[bufnr].filetype
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			if ft == "cfml" or ft == "cfm" or ft == "cfc" then
				return
			else
				return {
					async = true,
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			cs = { "csharpier" },
			json = { "prettier" },
			lua = { "stylua" },
			javascript = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			svelte = { "prettierd", "prettier " },
			xml = { "csharpier" },
			yaml = { "prettier" },
		},
		formatters = {
			csharpier = {
				command = "csharpier",
				args = function(self, ctx)
					return { "format", "--write-stdout", ctx.filename }
				end,
				stdin = true,
			},
			injected = { options = { ignore_errors = false } },
		},
	},
}
