local function is_dap_buffer()
	return require("cmp_dap").is_dap_buffer()
end
return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"alexandre-abrioux/blink-cmp-npm.nvim",
			"rcarriga/cmp-dap",
		},
		event = "VeryLazy",
		version = "*",
		opts = {
			keymap = {
				preset = "none",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-s>"] = { "show" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
				-- ["<C-a>"] = {
				-- 	function(cmp)
				-- 		if vim.b[vim.api.nvim_get_current_buf()].nes_state then
				-- 			cmp.hide()
				-- 			return require("copilot-lsp.nes").apply_pending_nes()
				-- 		end
				-- 		if cmp.snippet_active() then
				-- 			return cmp.accept()
				-- 		else
				-- 			return cmp.select_and_accept()
				-- 		end
				-- 	end,
				-- 	"snippet_forward",
				-- 	"fallback",
				-- },
				["<Tab>"] = {
					"snippet_forward",
					function()
						return require("sidekick").nes_jump_or_apply()
					end,
					function()
						return vim.lsp.inline_completion.get()
					end,
					"fallback",
				},
			},
			enabled = function()
				return vim.bo.buftype ~= "prompt" or is_dap_buffer()
			end,
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					border = "rounded",
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					window = {
						border = "rounded",
					},
				},
			},

			sources = {
				default = function()
					if is_dap_buffer() then
						return { "lazydev", "lsp", "npm", "easy-dotnet", "dadbod", "path", "snippets", "buffer", "dap" }
					end
					return { "lazydev", "lsp", "npm", "easy-dotnet", "dadbod", "path", "snippets", "buffer" }
				end,
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
					snippets = { min_keyword_length = 2 },
					dap = { name = "dap", module = "blink.compat.source" },
					["easy-dotnet"] = {
						name = "easy-dotnet",
						enabled = true,
						module = "easy-dotnet.completion.blink",
						score_offset = 10000,
						async = true,
					},
					npm = {
						name = "npm",
						module = "blink-cmp-npm",
						async = true,
						score_offset = 100,
						opts = {
							ignore = {},
							only_semantic_versions = true,
							only_latest_version = false,
						},
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
