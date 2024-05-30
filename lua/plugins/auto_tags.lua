return {
	-- Use treesitter to autoclose and autorename html tags | https://github.com/windwp/nvim-ts-autotag
	"windwp/nvim-ts-autotag",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-ts-autotag").setup()
	end,
}
