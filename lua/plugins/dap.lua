return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.set_log_level("TRACE")

			dap.listeners.after.event_initialized.dapui_config = function()
				dapui.open()
				vim.cmd("colorscheme " .. vim.g.colors_name)
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
				{ text = "", texthl = "DiagnosticError", linehl = "DapBreakpoint", numhl = "" }
			)
			vim.fn.sign_define("DapStopped", { text = "󰳟", texthl = "", linehl = "DapStopped", numhl = "" })

			require("dap-config.netcore").register_net_dap()
		end,
		keys = {
      -- stylua: ignore start
      {"<leader>dc", function() require("dap").continue() end, noremap = true, silent = true, desc = "continue",},
      {"<leader>do", function() require("dap").step_over() end, noremap = true, silent = true, desc = "step over",},
      {"<leader>di", function() require("dap").step_into() end, noremap = true, silent = true, desc = "step into",},
      {"<leader>du", function() require("dap").step_out() end, noremap = true, silent = true, desc = "step out",},
      {"<leader>dr", function() require("dap").restart() end, noremap = true, silent = true, desc = "restart",},
      {"<leader>dt", function() require("dap").terminate() end, noremap = true, silent = true, desc = "terminate",},
      {"<leader>db", function() require("dap").toggle_breakpoint() end, noremap = true, silent = true, desc = "toggle breakpoint",},
			-- stylua: ignore end
		},
		dependencies = {
			{ "jbyuki/one-small-step-for-vimkind" },
			{ "nvim-neotest/nvim-nio" },
			{
				"rcarriga/nvim-dap-ui",
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
		},
	},
}
-- return {
-- 	{
-- 		"mfussenegger/nvim-dap",
-- 		dependencies = {
-- 			"Cliffback/netcoredbg-macOS-arm64.nvim",
-- 			"rcarriga/nvim-dap-ui",
-- 		},
-- 		config = function()
-- 			local status, dap = pcall(require, "dap")
--
-- 			if not status then
-- 				print("dap not loaded")
-- 				return
-- 			end
--
-- 			-- local function get_netcoredbg_path()
-- 			-- 	local base_dir = vim.fn.stdpath("data") .. "/lazy/"
-- 			-- 	local netcoredbg_dir = "netcoredbg-macOS-arm64.nvim"
-- 			-- 	return base_dir .. netcoredbg_dir .. "/netcoredbg/netcoredbg"
-- 			-- end
-- 			--
-- 			-- local netcoredbg_path = get_netcoredbg_path()
--
-- 			-- dap.adapters.netcoredbg = {
-- 			-- 	type = "executable",
-- 			-- 	command = require("mason-registry").get_package("netcoredbg"):get_install_path() .. "/netcoredbg",
-- 			-- 	args = { "--interpreter=vscode" },
-- 			-- 	options = {
-- 			-- 		detached = false,
-- 			-- 	},
-- 			-- }
-- 			-- for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
-- 			-- 	if not dap.configurations[lang] then
-- 			-- 		dap.configurations[lang] = {
-- 			-- 			{
-- 			-- 				type = "netcoredbg",
-- 			-- 				name = "Launch file",
-- 			-- 				request = "launch",
-- 			-- 				program = function()
-- 			-- 					return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
-- 			-- 				end,
-- 			-- 				cwd = "${workspaceFolder}",
-- 			-- 			},
-- 			-- 		}
-- 			-- 	end
-- 			-- end
--
-- 			-- useful for debugging issues with dap
-- 			-- Logs are written to :lua print(vim.fn.stdpath('cache'))
-- 			-- dap.set_log_level("DEBUG") -- or `TRACE` for more logs
--
-- 			-- dap.configurations.cs = {
-- 			-- 	{
-- 			-- 		type = "coreclr",
-- 			-- 		name = "launch - API",
-- 			-- 		request = "launch",
-- 			-- 		-- console = "integratedTerminal",
-- 			-- 		justMyCode = false,
-- 			-- 		program = function()
-- 			-- 			return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/src/WebApi/bin/Debug", "file")
-- 			-- 		end,
-- 			-- 		cwd = function()
-- 			-- 			return vim.fn.input("Workspace folder: ", vim.fn.getcwd() .. "/src/WebApi", "file")
-- 			-- 		end,
-- 			-- 		env = {
-- 			-- 			ASPNETCORE_ENVIRONMENT = function()
-- 			-- 				return vim.fn.input("ASPNETCORE_ENVIRONMENT: ", "Development")
-- 			-- 			end,
-- 			-- 			ASPNETCORE_URLS = "https://localhost:5050",
-- 			-- 		},
-- 			-- 	},
-- 			-- }
-- 		end,
-- 	},
-- 	{
-- 		"jay-babu/mason-nvim-dap.nvim",
-- 		event = "VeryLazy",
-- 		dependencies = {
-- 			"williamboman/mason.nvim",
-- 			"mfussenegger/nvim-dap",
-- 		},
-- 		opts = {
-- 			handlers = {},
-- 		},
-- 	},
-- 	{
-- 		"rcarriga/nvim-dap-ui",
-- 		event = "VeryLazy",
-- 		dependencies = { "nvim-neotest/nvim-nio" },
-- 		keys = {
-- 			{
-- 				"<leader>du",
-- 				function()
-- 					require("dapui").toggle({})
-- 				end,
-- 				desc = "Dap UI",
-- 			},
-- 			{
-- 				"<leader>de",
-- 				function()
-- 					require("dapui").eval()
-- 				end,
-- 				desc = "Eval",
-- 				mode = { "n", "v" },
-- 			},
-- 		},
-- 		config = function()
-- 			local status, dap = pcall(require, "dap")
-- 			if not status then
-- 				print("dap not loaded")
-- 				return
-- 			end
-- 			local dap_status, dapui = pcall(require, "dapui")
-- 			if not dap_status then
-- 				print("dapui not loaded")
-- 				return
-- 			end
-- 			local status_ui, dap_ui = pcall(require, "dapui")
-- 			if not status_ui then
-- 				print("dapui not loaded")
-- 				return
-- 			end
-- 			dap_ui.setup({
-- 				controls = {
-- 					element = "repl",
-- 					enabled = true,
-- 					icons = {
-- 						disconnect = "",
-- 						pause = "",
-- 						play = "",
-- 						run_last = "",
-- 						step_back = "",
-- 						step_into = "",
-- 						step_out = "",
-- 						step_over = "",
-- 						terminate = "",
-- 					},
-- 				},
-- 				element_mappings = {},
-- 				expand_lines = true,
-- 				floating = {
-- 					border = "single",
-- 					mappings = {
-- 						close = { "q", "<Esc>" },
-- 					},
-- 				},
-- 				force_buffers = true,
-- 				icons = {
-- 					collapsed = "",
-- 					current_frame = "",
-- 					expanded = "",
-- 				},
-- 				layouts = {
-- 					{
-- 						elements = {
-- 							{
-- 								id = "console",
-- 								size = 0.2,
-- 							},
-- 							{
-- 								id = "breakpoints",
-- 								size = 0.2,
-- 							},
-- 							{
-- 								id = "stacks",
-- 								size = 0.2,
-- 							},
-- 							{
-- 								id = "repl",
-- 								size = 0.2,
-- 							},
-- 							{
-- 								id = "watches",
-- 								size = 0.2,
-- 							},
-- 						},
-- 						position = "left",
-- 						size = 50,
-- 					},
-- 					{
-- 						elements = {
-- 							{
-- 								id = "scopes",
-- 								size = 1,
-- 							},
-- 						},
-- 						position = "bottom",
-- 						size = 10,
-- 					},
-- 				},
-- 				mappings = {
-- 					edit = "e",
-- 					expand = { "<CR>", "<2-LeftMouse>" },
-- 					open = "o",
-- 					remove = "d",
-- 					repl = "r",
-- 					toggle = "t",
-- 				},
-- 				render = {
-- 					indent = 1,
-- 					max_value_lines = 100,
-- 				},
-- 			})
--
-- 			------------
-- 			-- Dap UI --
-- 			------------
--
-- 			dap.listeners.after.event_initialized["dapui_config"] = function()
-- 				dapui.open()
-- 			end
-- 			dap.listeners.before.event_terminated["dapui_config"] = function()
-- 				dapui.close()
-- 			end
-- 			dap.listeners.before.event_exited["dapui_config"] = function()
-- 				dapui.close()
-- 			end
--
-- 			vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
-- 			vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
-- 		end,
-- 	},
-- }
