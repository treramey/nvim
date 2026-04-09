return {
	"mrjones2014/smart-splits.nvim",
	keys = {
		{ "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Navigate left" },
		{ "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Navigate down" },
		{ "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Navigate up" },
		{ "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Navigate right" },
	},
	opts = {
		ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
		ignored_buftypes = { "nofile" },
	},
}
