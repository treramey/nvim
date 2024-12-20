local macchiato = require("catppuccin.palettes").get_palette("macchiato")
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = macchiato.mauve })

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			git = { enabled = true },
			gitbrowse = { enabled = true },
			lazygit = {
				configure = false,
				theme_path = vim.fs.normalize(vim.fn.expand("~/.config/lazygit/config.yml")),
			},
			indent = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>B",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch [B]uffer",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "[B]uffer [D]elete",
			},
			{
				"<leader>og",
				function()
					Snacks.gitbrowse()
				end,
				desc = "[O]pen [G]it",
				mode = { "n", "v" },
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Create some toggle mappings
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ul")
				end,
			})
		end,
	},
}
