local function has_git_conflict_markers()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for _, line in ipairs(lines) do
		if line:match("^<<<<<<<") or line:match("^=======") or line:match("^>>>>>>>") then
			return true
		end
	end
	return false
end

return {
	{
		"seblyng/roslyn.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"j-hui/fidget.nvim",
		},
		enabled = function()
			return vim.fn.executable("dotnet") == 1 and not has_git_conflict_markers()
		end,
		ft = "cs",
		config = function()
			require("roslyn").setup({
				broad_search = true,
				silent = true,
				on_attach = function(_, buffer_number)
					require("treramey.keymaps").map_lsp_keybinds(buffer_number)
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "roslyn" then
						require("treramey.keymaps").map_lsp_keybinds(args.buf)
					end
				end,
			})

			vim.api.nvim_create_autocmd({ "LspAttach", "InsertLeave" }, {
				pattern = "*",
				callback = function()
					local clients = vim.lsp.get_clients({ name = "roslyn" })
					if not clients or #clients == 0 then
						return
					end

					for _, client in ipairs(clients) do
						local buffers = vim.lsp.get_buffers_by_client_id(client.id)
						for _, buf in ipairs(buffers) do
							vim.diagnostic.reset(vim.lsp.diagnostic.get_namespace(client.id), buf)
							vim.lsp.codelens.refresh({ bufnr = buf })
						end
					end
				end,
			})
		end,
		init = function()
			local restore_handles = {}

			vim.keymap.set("n", "<leader>ns", function()
				if not vim.g.roslyn_nvim_selected_solution then
					return vim.notify("No solution file found")
				end

				local projects = require("roslyn.sln.api").projects(vim.g.roslyn_nvim_selected_solution)
				if not projects or #projects == 0 then
					return vim.notify("No projects found in solution")
				end

				local files = vim.iter(projects)
					:map(function(it)
						return vim.fs.dirname(it)
					end)
					:filter(function(dir)
						return dir and vim.fn.isdirectory(dir) == 1
					end)
					:totable()

				if #files == 0 then
					return vim.notify("No valid project directories found")
				end

				Snacks.picker.files({ dirs = files })
			end)
			vim.api.nvim_create_autocmd("User", {
				pattern = "RoslynRestoreProgress",
				callback = function(ev)
					local token = ev.data.params[1]
					local handle = restore_handles[token]
					if handle then
						handle:report({
							title = ev.data.params[2].state,
							message = ev.data.params[2].message,
						})
					else
						restore_handles[token] = require("fidget.progress").handle.create({
							title = ev.data.params[2].state,
							message = ev.data.params[2].message,
							lsp_client = {
								name = "roslyn",
							},
						})
					end
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "RoslynRestoreResult",
				callback = function(ev)
					local handle = restore_handles[ev.data.token]
					restore_handles[ev.data.token] = nil

					if handle then
						handle.message = ev.data.err and ev.data.err.message or "Restore completed"
						handle:finish()
					end
				end,
			})

			local init_handles = {}
			vim.api.nvim_create_autocmd("User", {
				pattern = "RoslynOnInit",
				callback = function(ev)
					init_handles[ev.data.client_id] = require("fidget.progress").handle.create({
						title = "Initializing Roslyn",
						message = ev.data.type == "solution"
								and string.format("Initializing Roslyn for %s", ev.data.target)
							or "Initializing Roslyn for project",
						lsp_client = {
							name = "roslyn",
						},
					})
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "RoslynInitialized",
				callback = function(ev)
					local handle = init_handles[ev.data.client_id]
					init_handles[ev.data.client_id] = nil

					if handle then
						handle.message = "Roslyn initialized"
						handle:finish()
					end
				end,
			})
		end,
		keys = {
			{ "<leader>nl", "<cmd>Roslyn restart<cr>", desc = "restart roslyn lsp" },
		},
	},
	{
		"GustavEikaas/easy-dotnet.nvim",
		enabled = function()
			return vim.fn.executable("dotnet") == 1 and not has_git_conflict_markers()
		end,
		dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
		ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
		cmd = "Dotnet",
		config = function()
			local dotnet = require("easy-dotnet")
			dotnet.setup({

				picker = "snacks",
				terminal = function(path, action, args)
					local args_str = args or ""
					local terminal_opts = {
						win = {
							position = "bottom",
							height = 0.20,
						},
					}
					local commands = {
						run = function()
							return string.format("dotnet run --project %s %s", path, args_str)
						end,
						test = function()
							return string.format("dotnet test %s %s", path, args_str)
						end,
						restore = function()
							return string.format("dotnet restore %s %s", path, args_str)
						end,
						build = function()
							return string.format("dotnet build %s %s", path, args_str)
						end,
						watch = function()
							return string.format("dotnet watch --project %s %s", path, args_str)
						end,
					}

					local cmd = commands[action]()
					Snacks.terminal.toggle(cmd, terminal_opts)
				end,
				auto_bootstrap_namespace = {
					type = "file_scoped",
					enabled = true,
				},
				test_runner = {
					viewmode = "float",
					icons = {
						project = "󰗀",
					},
				},
			})
		end,
		keys = {
      -- stylua: ignore start 
      { "<leader>nw", function() require("easy-dotnet").watch_default() end, desc = "watch solution" },
      { "<leader>nb", function() require("easy-dotnet").build_default_quickfix() end, desc = "build default quickfix" },
      { "<leader>nB", function() require("easy-dotnet").build_default() end, desc = "build default" },
      -- { "<leader>ns", function() require("easy-dotnet").build_solution() end, desc = "build solution" },
      { "<leader>nr", function() require("easy-dotnet").restore() end, desc = "restore packages" },
      { "<leader>nQ", function() require("easy-dotnet").build_quickfix() end, desc = "build quickfix" },
      { "<leader>nR", function() require("easy-dotnet").run_solution() end, desc = "run solution" },
      { "<leader>nx", function() require("easy-dotnet").clean() end, desc = "clean solution" },
      { "<leader>nn", "<cmd>Dotnet<cr>", desc = "open dotnet menu" },
      { "<leader>na", "<cmd>Dotnet new<cr>", desc = "new item" },
      { "<leader>nt", "<cmd>Dotnet testrunner<cr>", desc = "open test runner" },
			-- stylua: ignore end
		},
	},
}
