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

			if ft == "cfml" or ft == "cfm" or ft == "cfc" then
				return {
					async = true,
					timeout_ms = 500,
					lsp_format = "never",
				}
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
				args = {
					"--selfclose",
					"--indent",
					"1",
					"--indent-char",
					"\t",
					"--preserve",
					'"literal"',
					"--blanks",
					"-",
				},
			},
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
