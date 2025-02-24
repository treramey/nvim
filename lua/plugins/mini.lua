return {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {},
		config = function()
			require("nvim-treesitter.configs").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {},
		config = function()
			-- Setup the correct comment string
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.cfc", "*.cfs", "*.bx", "*.bxs" },
				callback = function()
					vim.opt.commentstring = "// %s"
				end,
			})

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.cfm", "*.bxm" },
				callback = function()
					vim.opt.commentstring = "<!--- %s --->"
				end,
			})

			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	{
		"echasnovski/mini.diff",
		version = false,
		lazy = true,
		opts = {
			view = {
				style = "sign",
				signs = { add = "┃", change = "┃", delete = "_" },
			},
		},
	},
	{ "echasnovski/mini-git", lazy = true, version = false, main = "mini.git", opts = {} },
	{
		"echasnovski/mini.icons",
		opts = {
			file = {
				["init.lua"] = { glyph = "󰢱", hl = "MiniIconsAzure" },
			},
			lsp = {
				copilot = { glyph = "", hl = "MiniIconsOrange" },
				snippet = { glyph = "" },
			},
		},
		lazy = true,
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
}
