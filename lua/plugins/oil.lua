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
					["<C-l>"] = function()
						local oil = require("oil")
						local entry = oil.get_cursor_entry()
						local dir = oil.get_current_dir()

						if entry and entry.type == "directory" then
							-- Ensure proper path separator
							dir = dir .. (dir:sub(-1) == "/" and "" or "/") .. entry.name
						end

						-- Add error handling for easy-dotnet
						local ok, easy_dotnet = pcall(require, "easy-dotnet")
						if ok and easy_dotnet.create_new_item then
							easy_dotnet.create_new_item(dir)
						else
							vim.notify("easy-dotnet plugin not available", vim.log.levels.WARN)
						end
					end,
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
