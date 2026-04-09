return {
	{
		"mistweaverco/kulala.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			{ "<leader>rs", desc = "send request" },
			{ "<leader>ra", desc = "send all requests" },
			{ "<leader>rb", desc = "open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {},
	},
}
