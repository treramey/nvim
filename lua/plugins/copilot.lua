return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				debounce = 25,
				keymap = {
					accept = false,
					accept_word = false,
					accept_line = "<Tab>",
					next = false,
					prev = false,
					dismiss = false,
				},
			},
			panel = { enabled = false },
		},
	},
	{
		"olimorris/codecompanion.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				inline = {
					adapter = "copilot",
				},
				chat = {
					adapter = "copilot",
					roles = {
						llm = " Copilot",
						user = " Me",
					},
					slash_commands = {
						["file"] = {
							callback = "strategies.chat.slash_commands.file",
							description = "Select a file using Telescope",
							opts = {
								provider = "telescope",
								contains_code = true,
							},
						},
					},
				},
				display = {
					chat = {
						render_headers = false,
					},
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
						},
					})
				end,
			},
		},
    -- stylua: ignore start
		keys = {
			{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "x" }, desc = "actions" },
			{ "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "x" }, desc = "toggle" },
			{ "<leader>ab", "<cmd>CodeCompanionChat Add<cr><esc>", mode = "v", noremap = true, silent = true, desc = "add" },
		},
    -- stylua: ignore stop

		init = function()
      require("plugins.codecompanion.fidget-spinner"):init()
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function(opts)
					if vim.bo[opts.buf].filetype == "codecompanion" then
						vim.opt_local.relativenumber = false
						vim.opt_local.number = false
					end
				end,
			})
		end,
	},
	{
		"PLAZMAMA/bunnyhop.nvim",
		keys = {
			{
				"<leader>aj",
				function()
					require("bunnyhop").hop()
				end,
				desc = "hop to predicted location.",
			},
		},
		opts = {},
	},
}
