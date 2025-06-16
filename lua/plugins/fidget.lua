return {
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		config = function()
			require("fidget").setup({
				notification = {
					window = {
						winblend = 0,
					},
				},
				progress = {
					display = {
						progress_icon = { pattern = "dots_negative" },
					},
				},
			})
		end,
	},
}
