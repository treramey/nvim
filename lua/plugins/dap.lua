return {
	{
		"rcarriga/nvim-dap-ui",
		keys = {
      -- stylua: ignore start
        {"<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
        {"<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" },},
			-- stylua: ignore end
		},
		config = function()
			require("dapui").setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				mappings = {
					expand = { "<CR>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				element_mappings = {},
				expand_lines = true,
				force_buffers = true,
				layouts = {
					{
						elements = { { id = "scopes", size = 0.33 }, { id = "repl", size = 0.66 } },
						size = 10,
						position = "bottom",
					},
					{
						elements = { "breakpoints", "console", "stacks", "watches" },
						size = 45,
						position = "right",
					},
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "single",
					mappings = { ["close"] = { "q", "<Esc>" } },
				},
				controls = {
					enabled = vim.fn.exists("+winbar") == 1,
					element = "repl",
					icons = {
						pause = "",
						play = "",
						step_into = "",
						step_over = "",
						step_out = "",
						step_back = "",
						run_last = "",
						terminate = "",
						disconnect = "",
					},
				},
				render = { max_type_length = nil, max_value_lines = 100, indent = 1 },
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"jbyuki/one-small-step-for-vimkind",
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			{
				"Weissle/persistent-breakpoints.nvim",
				event = { "BufReadPre", "BufNewFile" },
				config = function()
					require("persistent-breakpoints").setup({
						load_breakpoints_event = { "BufReadPost" },
					})
				end,
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.set_log_level("TRACE")

			dap.listeners.after.event_initialized.dapui_config = function()
				dapui.open()
				-- vim.cmd("colorscheme " .. vim.g.colors_name)
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "" }
			)
			vim.fn.sign_define("DapStopped", { text = "󰳟", texthl = "", linehl = "DapStopped", numhl = "" })

			require("dap-config.netcore").register_net_dap()
		end,
		keys = {
      -- stylua: ignore start

      {"<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      {"<leader>dB", function() require("persistent-breakpoints.api").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },

      {"<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      {"<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      {"<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      {"<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      {"<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      {"<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      {"<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },

      {"<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      {"<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      {"<leader>ds", function() require("dap").session() end, desc = "Session" },

      {"<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },

      {"<leader>dj", function() require("dap").down() end, desc = "Stack Down" },
      {"<leader>dk", function() require("dap").up() end, desc = "Stack Up" },

      {"<F5>", function() require("dap").continue() end, desc = "Continue" },
      {"<F10>", function() require("dap").step_over() end, desc = "Step Over" },
      {"<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      {"<F12>", function() require("dap").step_out() end, desc = "Step Out" },
      {"<F9>", function() require("persistent-breakpoints.api").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      {"<S-F9>", function() require("persistent-breakpoints.api").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
      {"<F8>", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      {"<S-F5>", function() require("dap").terminate() end, desc = "Terminate" },

			-- stylua: ignore end
		},
	},
}
