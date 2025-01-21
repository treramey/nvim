local macchiato = require("catppuccin.palettes").get_palette("macchiato")
local filtered_message = { "No information available" }

vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = macchiato.mauve })

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
			dashboard = {
				formats = {
					key = function(item)
						return { { "[", hl = "function" }, { item.key, hl = "key" }, { "]", hl = "function" } }
					end,
					header = { "%s", align = "center", hl = "MiniIconsBlue" },
					icon = function(item)
						if item.file and item.icon == "file" or item.icon == "directory" then
							return Snacks.dashboard.icon(item.file, item.icon)
						end
						return { item.icon, width = 2, hl = "MiniIconsPurple" }
					end,
				},
				preset = {
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "find file",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{
							icon = " ",
							key = "w",
							desc = "find text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "recent files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{ icon = " ", key = "e", desc = "explorer", action = ":lua require('oil').toggle_float()" },
						{ icon = " ", key = "g", desc = "browse git", action = ":lua Snacks.lazygit()" },
						{ icon = "󰒲 ", key = "l", desc = "lazy", action = ":Lazy" },
						{ icon = "󱌣 ", key = "m", desc = "mason", action = ":Mason" },
						{ icon = "󰭿 ", key = "q", desc = "quit", action = ":qa" },
					},
				},
				sections = {
					{
						section = "terminal",
						cmd = "chafa /Users/trevor/Downloads/1332280.jpeg --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
						height = 17,
						padding = 1,
					},
					{
						pane = 2,
						{ title = "shortcuts", hl = "" },
						{ section = "keys", padding = 1 },
						{ title = "mru ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
						{ section = "recent_files", cwd = true, limit = 5, padding = 1 },
						{ section = "startup" },
					},
				},
			},
			git = { enabled = true },
			gitbrowse = { enabled = true },
			lazygit = {
				configure = false,
				theme_path = vim.fs.normalize(vim.fn.expand("~/.config/lazygit/config.yml")),
			},
			indent = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
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
			{ "<leader>z", function() Snacks.toggle.dim():toggle() end, desc = "Toggle [Z]en Mode" },
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
