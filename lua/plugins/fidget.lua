return {
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		config = function()
			-- Turn on LSP, formatting, and linting status and progress information
			require("fidget").setup({
				progress = {
					display = {
						progress_icon = { pattern = "dots_negative" },
					},
				},
			})
		end,
	},
}
