vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.opt_local.colorcolumn = ""
	end,
})

return {
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("oil").setup({
				-- use_default_keymaps = false,
				keymaps = {
					["<C-_>"] = { "actions.select", opts = { vertical = true } },
					["q"] = { "actions.close", mode = "n" },
					["<tab>"] = "actions.select",
					["<s-tab>"] = "actions.parent",
					["<leader>cd"] = { "actions.cd", mode = "n" },
					["<leader>ct"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				},
				view_options = {
					show_hidden = true,
				},
			})
		end,
	},
}
