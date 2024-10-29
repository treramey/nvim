return {
	-- {
	-- 	"braxtons12/blame_line.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("blame_line").setup({
	-- 			prefix = " ",
	-- 		})
	-- 	end,
	-- },
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			signs = {
				add = { text = "▏" },
				change = { text = "▏" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▏" },
				untracked = { text = "▏" },
			},
		},
		current_line_blame = true,
		current_line_blame_formatter = " <author>, <author_time> · <summary> ",
		config = function()
			require("gitsigns").setup({
				-- current_line_blame = false,
			})
		end,
	},
}
