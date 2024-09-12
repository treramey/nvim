return {
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
		config = function()
			require("nvim-web-devicons").setup({
				override = {
					astro = {
						icon = "",
						color = "#EF8547",
						name = "astro",
					},
					gleam = {
						icon = "",
						color = "#ffaff3",
						name = "Gleam",
					},
					prettier = {
						icon = "",
						color = "#ffaff3",
						name = "preitter",
					},
				},
			})
		end,
	},
}
