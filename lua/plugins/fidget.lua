return {
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		config = function()
			require("fidget").setup({
				progress = {
					display = {
						progress_icon = { pattern = "dots_negative" },
					},
				},
				notification = {
					window = {
						winblend = 0,
					},
				},
			})
		end,
	},
}
