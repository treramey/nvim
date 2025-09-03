vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.colorcolumn = ""
	end,
})

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
		opts = {
			file_types = { "markdown", "copilot-chat", "codecompanion" },
			code = {
				sign = true,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = { " " }, -- stylua: ignore
				position = "inline",
			},
			pipe_table = { alignment_indicator = "┅" },
		},
		ft = { "markdown", "copilot-chat", "codecompanion" },
	},
}
