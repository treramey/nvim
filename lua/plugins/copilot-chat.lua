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

---@param kind string
function pick(kind)
	return function()
		local actions = require("CopilotChat.actions")
		local items = actions[kind .. "_actions"]()
		if not items then
			vim.notify("No " .. kind .. " found on the current line", vim.log.levels.WARN)
			return
		end
		require("CopilotChat.integrations.telescope").pick(items)
	end
end

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
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
				model = "claude-3.5-sonnet",
				auto_insert_mode = true,
				auto_follow_cursor = false,
				show_folds = false,
				show_help = true,
				question_header = "   " .. user .. " ",
				answer_header = "   Copilot ",
				window = { width = 0.45 },
				prompts = prompts,
				selection = function(source)
					local select = require("CopilotChat.select")
					return select.visual(source) or select.buffer(source)
				end,
				mappings = {
					reset = {
						normal = "<C-e>",
						insert = "<C-e>",
					},
					submit_prompt = {
						normal = "<CR>",
						insert = "<C-CR>",
					},
				},
			}
		end,
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>ai",
				"<cmd>CopilotChatToggle<cr>",
				desc = "Toggle Chat",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				"<cmd>CopilotChatReset<cr>",
				desc = "Clear Chat",
				mode = { "n", "v" },
			},
			-- Quick chat with Copilot
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "Quick chat",
			},
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
			-- Code related commands
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = { "v" }, desc = "CopilotChat - Explain code" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", mode = { "v" }, desc = "CopilotChat - Generate tests" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>", mode = { "v" }, desc = "CopilotChat - Review code" },
			{ "<leader>aR", "<cmd>CopilotChatRefactor<cr>", mode = { "v" }, desc = "CopilotChat - Refactor code" },
			{
				"<leader>an",
				"<cmd>CopilotChatBetterNamings<cr>",
				mode = { "v" },
				desc = "CopilotChat - Better Naming",
			},
			{ "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
			-- Fix the issue with diagnostic
			{ "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },

			{ "<leader>ad", pick("help"), desc = "Diagnostic Help", mode = { "n", "v" } },
			{ "<leader>ap", pick("prompt"), desc = "Prompt Actions", mode = { "n", "v" } },
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")

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

			chat.setup(opts)
			-- Setup the CMP integration
			chat_autocomplete = true

			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = select.visual })
			end, { nargs = "*", range = true })

			-- Inline chat with Copilot
			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.3,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })

			-- Restore CopilotChatBuffer
			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { selection = select.buffer })
			end, { nargs = "*", range = true })

			-- Custom buffer for CopilotChat
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
					vim.opt_local.colorcolumn = ""

					-- -- Get current filetype and set it to markdown if the current filetype is copilot-chat
					-- local ft = vim.bo.filetype
					-- if ft == "copilot-chat" then
					-- 	vim.bo.filetype = "markdown"
					-- end
				end,
			})
		end,
	},
}
