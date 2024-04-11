return {
	{
		"luckasRanarison/tailwind-tools.nvim",
		ft = {
			"javascriptreact",
			"typescriptreact",
			"html",
			"markdown",
			"mdx",
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			document_color = {
				enabled = true,
				kind = "inline",
				inline_symbol = "󰝤 ",
				debounce = 200,
			},
			conceal = {
				enabled = true,
				symbol = "󱏿",
				highlight = {
					fg = "#38BDF8",
				},
			},
		},
		config = function(_, opts)
			require("tailwind-tools").setup(opts)
		end,
	},
}
