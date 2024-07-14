local prompts = {
	-- Code related prompts
	Explain = "Please explain how the following code works.",
	Review = "Please review the following code and provide suggestions for improvement.",
	Tests = "Please explain how the selected code works, then generate unit tests for it.",
	Refactor = "Please refactor the following code to improve its clarity and readability.",
	FixCode = "Please fix the following code to make it work as intended.",
	FixError = "Please explain the error in the following text and provide a solution.",
	BetterNamings = "Please provide better names for the following variables and functions.",
	Documentation = "Please provide documentation for the following code.",
	SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
	SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
	-- Text related prompts
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		event = "VeryLazy",
		cmd = "CopilotChat",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				model = "gpt-4",
				auto_insert_mode = true,
				show_help = true,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				separator = "---",
				prompts = prompts,
				window = {
					width = 0.4,
				},
				selection = function(source)
					local select = require("CopilotChat.select")
					return select.visual(source) or select.buffer(source)
				end,
			}
		end,
		keys = {
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			-- Code related commands
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
			{ "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
			-- Generate commit message based on the git diff
			{
				"<leader>am",
				"<cmd>CopilotChatCommit<cr>",
				desc = "CopilotChat - Generate commit message for all changes",
			},
			{
				"<leader>aM",
				"<cmd>CopilotChatCommitStaged<cr>",
				desc = "CopilotChat - Generate commit message for staged changes",
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")

			local ns = vim.api.nvim_create_namespace("copilot-chat-text-hl")

			-- Override the git prompts message
			opts.prompts.Commit = {
				prompt = "Write commit message for the change with commitizen convention",
				selection = select.gitdiff,
			}
			opts.prompts.CommitStaged = {
				prompt = "Write commit message for the change with commitizen convention",
				selection = function(source)
					return select.gitdiff(source, true)
				end,
			}

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function(ev)
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false

					vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
						group = vim.api.nvim_create_augroup("copilot-chat-text-" .. ev.buf, { clear = true }),
						buffer = ev.buf,
						callback = function()
							vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1)
							local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
							for l, line in ipairs(lines) do
								if line:match(opts.separator .. "$") then
									local sep = vim.fn.strwidth(line) - vim.fn.strwidth(opts.separator)
									if sep > 0 then
										vim.api.nvim_buf_set_extmark(ev.buf, ns, l - 1, sep, {
											virt_text_win_col = sep,
											virt_text = {
												{ string.rep("─", vim.go.columns), "@punctuation.special.markdown" },
											},
											priority = 100,
										})
										vim.api.nvim_buf_set_extmark(ev.buf, ns, l - 1, 0, {
											end_col = sep + 1,
											hl_group = "@markup.heading.2.markdown",
											priority = 100,
										})
									end
								end
							end
						end,
					})
				end,
			})

			chat.setup(opts)
		end,
	},

	-- Edgy integration
	{
		"folke/edgy.nvim",
		optional = true,
		opts = function(_, opts)
			opts.right = opts.right or {}
			table.insert(opts.right, {
				ft = "copilot-chat",
				title = "Copilot Chat",
				size = { width = 50 },
			})
		end,
	},
}
