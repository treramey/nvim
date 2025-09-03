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
		"nvim-mini/mini.comment",
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
						local ft = vim.bo.filetype
						local ext = vim.fn.expand("%:e")

						-- C# files
						if ft == "cs" then
							return "// %s"
						end

						-- ColdFusion component/script files
						if ext == "cfc" or ext == "cfs" or ext == "bx" or ext == "bxs" then
							return "// %s"
						end

						-- ColdFusion markup files
						if ext == "cfm" or ext == "bxm" then
							return "<!--- %s --->"
						end

						-- Fall back to ts_context_commentstring or default commentstring
						return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
					end,
					pad_comment_parts = true,
				},
			})
		end,
	},
	{
		"nvim-mini/mini.ai",
		version = false,
		config = function()
			require("mini.ai").setup({})
		end,
	},
	{
		"nvim-mini/mini.diff",
		version = false,

		opts = {
			view = {
				style = "sign",
				signs = { add = "┃", change = "┃", delete = "_" },
			},
		},
	},
	{ "nvim-mini/mini-git", lazy = true, version = false, main = "mini.git", opts = {} },
	{
		"nvim-mini/mini.icons",
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
