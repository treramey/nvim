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
}
