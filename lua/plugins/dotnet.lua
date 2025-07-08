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
		"seblj/roslyn.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		enabled = function()
			return vim.fn.executable("dotnet") == 1 and not has_git_conflict_markers()
		end,
		ft = "cs",
		opts = function()
			local map_lsp_keybinds = require("treramey.keymaps").map_lsp_keybinds

			local on_attach = function(_, bufnr)
				map_lsp_keybinds(bufnr)
			end

			vim.api.nvim_create_autocmd({ "LspAttach", "InsertLeave" }, {
				pattern = "*",
				callback = function()
					local clients = vim.lsp.get_clients({ name = "roslyn" })
					if not clients or #clients == 0 then
						return
					end

					local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
					for _, buf in ipairs(buffers) do
						vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = buf })
						vim.lsp.codelens.refresh()
					end
				end,
			})

			vim.lsp.config("roslyn", {
				on_attach = on_attach,
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
					},
				},
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
      { "<leader>nb", function() require("easy-dotnet").build_default() end, desc = "build default" },
      { "<leader>nB", function() require("easy-dotnet").build() end, desc = "build" },
      { "<leader>ns", function() require("easy-dotnet").build_solution() end, desc = "build solution" },
      { "<leader>nr", function() require("easy-dotnet").restore() end, desc = "restore packages" },
      { "<leader>nq", function() require("easy-dotnet").build_default_quickfix() end, desc = "build default quickfix" },
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
