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
				width = "full",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = { " " },
				position = "inline",
			},
			pipe_table = { alignment_indicator = "┅" },
			completions = { lsp = { enabled = true } },
		},
		ft = { "markdown", "copilot-chat", "codecompanion" },
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{ "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},
}
