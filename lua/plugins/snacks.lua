local macchiato = require("catppuccin.palettes").get_palette("macchiato")
local filtered_message = { "No information available" }

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		dependencies = {
			{
				"lewis6991/gitsigns.nvim",
				init = function()
					require("gitsigns").setup()
				end,
			},
		},
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dim = { enabled = true },
			indent = {
				enabled = true,
				filter = function(buf)
					local b = vim.b[buf]
					local bo = vim.bo[buf]
					local excluded_filetypes = {
						markdown = true,
						text = true,
					}
					return vim.g.snacks_indent ~= false
						and b.snacks_indent ~= false
						and bo.buftype == ""
						and not excluded_filetypes[bo.filetype]
				end,
			},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			lazygit = {
				configure = false,
				theme_path = vim.fs.normalize(vim.fn.expand("~/.config/lazygit/config.yml")),
			},
			picker = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			terminal = {},
			words = { enabled = true },
			zen = { enabled = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					local notify = Snacks.notifier.notify
					---@diagnostic disable-next-line: duplicate-set-field
					Snacks.notifier.notify = function(message, level, opts)
						for _, msg in ipairs(filtered_message) do
							if message == msg then
								return nil
							end
						end
						return notify(message, level, opts)
					end
				end,
			})
		end,
    -- stylua: ignore start
		keys = {
			{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
			{ "<leader>B", function() Snacks.scratch.select() end, desc = "Select Scratch [B]uffer" },
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "[B]uffer [D]elete" },
			{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame Line" },
			{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
			{ "<leader>og", function() Snacks.gitbrowse() end, desc = "[O]pen [G]it", mode = { "n", "v" } },
			{ "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
			{ "<leader>dn", function() Snacks.notifier.hide() end, desc = "[D]ismiss All [N]otifications" },
			{ "<leader>nh", function() Snacks.notifier.show_history() end, desc = "[N]otification [H]istory" },
			{ "<leader>zz", function() Snacks.toggle.dim():toggle() end, desc = "Toggle [Z]en Mode" },
			{ "<leader>cl", function() Snacks.toggle.option("cursorline", { name = "Cursor Line" }):toggle() end, desc = "Toggle [C]ursor [L]ine" },
			{ "<leader>td", function() Snacks.toggle.diagnostics():toggle() end, desc = "[T]oggle [D]iagnostics" },
      { "<leader>_", function() Snacks.terminal() end, desc = "terminal" },
			{ "<leader>ln",
				function()
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):toggle()
				end,
				desc = "Toggle Relative [L]ine [N]umbers",
			},
			{
				"<leader>tt",
				function()
					local tsc = require("treesitter-context")
					Snacks.toggle({
						name = "Treesitter Context",
						get = tsc.enabled,
						set = function(state)
							if state then
								tsc.enable()
							else
								tsc.disable()
							end
						end,
					}):toggle()
				end,
				desc = "[T]oggle [T]reesitter Context",
			},
			{
				"<leader>hl",
				function()
					local hc = require("nvim-highlight-colors")
					Snacks.toggle({
						name = "Highlight Colors",
						get = function()
							return hc.is_active()
						end,
						set = function(state)
							if state then
								hc.turnOn()
							else
								hc.turnOff()
							end
						end,
					}):toggle()
				end,
				desc = "Toggle [H]igh[L]ight Colors",
			},
		},
		-- stylua: ignore end
	},
}
