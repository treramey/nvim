return {
	"m4xshen/hardtime.nvim",
	lazy = true,
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {
		hints = {
			["[dcyvV][ia][%(%)]"] = {
				message = function(keys)
					return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
				end,
				length = 3,
			},
		},
	},
	keys = {
		{ "<leader>th", "<cmd>Hardtime toggle<cr>", desc = "hardtime" },
	},
}
