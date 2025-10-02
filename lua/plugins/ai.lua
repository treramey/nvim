return {
	-- {
	-- 	"copilotlsp-nvim/copilot-lsp",
	-- 	init = function()
	-- 		vim.g.copilot_nes_debounce = 500
	-- 		vim.lsp.enable("copilot_ls")
	-- 		vim.keymap.set("n", "<C-y>", function()
	-- 			local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
	-- 				or (
	-- 					require("copilot-lsp.nes").apply_pending_nes()
	-- 					and require("copilot-lsp.nes").walk_cursor_end_edit()
	-- 				)
	-- 		end)
	-- 		vim.keymap.set("n", "<esc>", function()
	-- 			if not require("copilot-lsp.nes").clear() then
	-- 				-- fallback to other functionality
	-- 			end
	-- 		end, { desc = "Clear Copilot suggestion or fallback" })
	-- 	end,
	-- },
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	cmd = "Copilot",
	-- 	build = ":Copilot auth",
	-- 	event = "InsertEnter",
	-- 	opts = {
	-- 		suggestion = {
	-- 			enabled = true,
	-- 			auto_trigger = true,
	-- 			hide_during_completion = false,
	-- 			debounce = 25,
	-- 			keymap = {
	-- 				accept = false,
	-- 				accept_word = false,
	-- 				accept_line = "<C-y>",
	-- 				next = false,
	-- 				prev = false,
	-- 				dismiss = false,
	-- 			},
	-- 		},
	-- 		panel = { enabled = false },
	-- 	},
	-- },
	{
		"folke/sidekick.nvim",
		event = "VeryLazy",
		opts = {
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<C-f>",
				function()
					if require("sidekick").nes_jump_or_apply() then
						return -- jumped or applied
					end

					if vim.lsp.inline_completion.get() then
						return
					end

					return "<C-f>"
				end,
				mode = { "i", "n" },
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ focus = true })
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").select_prompt()
				end,
				desc = "Sidekick Ask Prompt",
				mode = { "n", "v" },
			},
		},
	},
	-- {
	-- 	"olimorris/codecompanion.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"zbirenbaum/copilot.lua",
	-- 	},
	-- 	opts = {
	-- 		strategies = {
	-- 			inline = {
	-- 				adapter = "copilot",
	-- 			},
	-- 			chat = {
	-- 				name = "copilot",
	-- 				model = "claude-sonnet-4",
	-- 				roles = {
	-- 					llm = " Copilot",
	-- 					user = " treramey",
	-- 				},
	-- 			},
	-- 		},
	-- 		display = {
	-- 			chat = {
	-- 				render_headers = false,
	-- 			},
	-- 			action_palette = {
	-- 				provider = "default",
	-- 			},
	-- 		},
	-- 	},
	-- 	keys = {
	-- 		{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "x" }, desc = "actions" },
	-- 		{ "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "x" }, desc = "toggle" },
	-- 	},
	-- 	init = function()
	-- 		vim.api.nvim_create_autocmd("BufEnter", {
	-- 			callback = function(opts)
	-- 				if vim.bo[opts.buf].filetype == "codecompanion" then
	-- 					vim.opt_local.relativenumber = false
	-- 					vim.opt_local.number = false
	-- 				end
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"NickvanDyke/opencode.nvim",
	-- 	init = function()
	-- 		vim.g.opencode_opts = {
	-- 			terminal = {
	-- 				env = {
	-- 					OPENCODE_THEME = "rosepine",
	-- 				},
	-- 			},
	-- 		}
	-- 	end,
	-- 	keys = {
	--      -- stylua: ignore start
	--      -- Recommended keymaps
	--      { "<leader>oA", function() require("opencode").ask() end, desc = "Ask opencode" },
	--      { "<leader>oa", function() require("opencode").ask "@cursor: " end, desc = "Ask opencode about this", mode = "n" },
	--      { "<leader>oa", function() require("opencode").ask "@selection: " end, desc = "Ask opencode about selection", mode = "v" },
	--      { "<leader>ot", function() require("opencode").toggle() end, desc = "Toggle embedded opencode" },
	--      { "<leader>on", function() require("opencode").command "session_new" end, desc = "New session" },
	--      { "<leader>oy", function() require("opencode").command "messages_copy" end, desc = "Copy last message" },
	--      { "<S-C-u>", function() require("opencode").command "messages_half_page_up" end, desc = "Scroll messages up" },
	--      { "<S-C-d>", function() require("opencode").command "messages_half_page_down" end, desc = "Scroll messages down" },
	--      { "<leader>op", function() require("opencode").select_prompt() end, desc = "Select prompt", mode = { "n", "v" } },
	--      -- Example: keymap for custom prompt
	--      { "<leader>oe", function() require("opencode").prompt "Explain @cursor and its context" end, desc = "Explain code near cursor" },
	-- 		-- stylua: ignore end
	-- 	},
	-- },
}
