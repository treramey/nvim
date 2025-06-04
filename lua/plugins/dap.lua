return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "igorlfs/nvim-dap-view", opts = {} },
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
				opts = {
					winbar = {
						controls = {
							enabled = true,
						},
					},
				},
			},
		},
		config = function()
			local dap, dv = require("dap"), require("dap-view")
			dap.set_log_level("TRACE")

			dap.listeners.before.attach["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.launch["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.event_terminated["dap-view-config"] = function()
				dv.close()
			end
			dap.listeners.before.event_exited["dap-view-config"] = function()
				dv.close()
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
