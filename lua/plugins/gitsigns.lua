return {
	{
		"braxtons12/blame_line.nvim",
		event = "VeryLazy",
		config = function()
			require("blame_line").setup({
				prefix = " ",
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				current_line_blame = false,
			})
		end,
	},
}
