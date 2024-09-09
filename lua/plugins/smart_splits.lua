return {
	"mrjones2014/smart-splits.nvim",
	opts = {
		ignored_filetypes = {
			"nofile",
			"quickfix",
			"qf",
			"prompt",
		},
		ignored_buftypes = { "nofile" },
	},
	config = function(_, opts)
		require("smart-splits").setup(opts)
	end,
}
