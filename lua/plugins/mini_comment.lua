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
			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
					end,
				},
			})
		end,
	},
}
