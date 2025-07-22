return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = false,
					auto_trigger = false,
					hide_during_completion = false,
					debounce = 25,
					keymap = {
						accept = false,
						accept_word = false,
						accept_line = "<C-y>",
						next = false,
						prev = false,
						dismiss = false,
					},
				},
				panel = { enabled = false },
				server_opts_overrides = {},
			})
		end,
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
							description = "Select a file using snacks",
							opts = {
								provider = "snacks",
								contains_code = true,
							},
						},
					},
				},
				display = {
					action_palette = {
						provider = "default",
					},
					chat = {
						render_headers = false,
					},
					diff = {
						provider = "mini_diff",
					},
				},
			},
			prompt_library = {
				["Alphabetize Buffer"] = {
					strategy = "workflow",
					description = "Alphabetize all lines in the current buffer using shell tools",
					opts = {
						placement = "replace",
						auto_submit = true,
						short_name = "alpha",
					},
					prompts = {
						{
							{
								role = "system",
								content = [[You are a text processing assistant with access to shell tools. Your task is to alphabetize the lines in the current buffer using the cmd_runner tool.

You have access to the following tools:
- cmd_runner: Execute shell commands
- editor: Edit buffer content directly

Use the cmd_runner tool to execute the `sort` command for reliable alphabetization. The workflow should:
1. Get the current buffer content
2. Use `sort -f` (case-insensitive) to alphabetize the lines
3. Replace the buffer content with the sorted result

Always use the tools available to you rather than trying to manually sort text.]],
							},
							{
								role = "user",
								content = function(context)
									local lines = vim.api.nvim_buf_get_lines(context.bufnr, 0, -1, false)
									local content = table.concat(lines, "\n")
									return string.format(
										[[Please alphabetize the content of buffer %d using the cmd_runner tool. The current content is:

%s

Use the sort command with case-insensitive sorting to alphabetize these lines, then replace the buffer content with the sorted result.]],
										context.bufnr,
										content
									)
								end,
							},
						},
					},
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-sonnet-4",
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
}
