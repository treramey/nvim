return {
	{
		enabled = vim.fn.executable("dotnet") == 1,
		"seblj/roslyn.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		ft = "cs",
		opts = function()
			local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds

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
			return {
				config = {
					on_attach = on_attach,
					settings = {
						["csharp|code_lens"] = {
							dotnet_enable_references_code_lens = true,
						},
					},
				},
			}
		end,
		keys = {
			{ "<leader>nl", "<cmd>Roslyn restart<cr>", desc = "restart roslyn lsp" },
		},
	},
	{
		"GustavEikaas/easy-dotnet.nvim",
		enabled = vim.fn.executable("dotnet") == 1,
		dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
		ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
		cmd = "Dotnet",
		config = function()
			local dotnet = require("easy-dotnet")
			dotnet.setup({

				picker = "snacks",
				terminal = function(path, action, args)
					local args_str = args or ""
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

					local cmd = commands[action]() .. "\r"
					require("snacks").terminal.open(cmd)
				end,
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
      { "<leader>nb", function() require("easy-dotnet").build_default_quickfix() end, desc = "build" },
      { "<leader>nB", function() require("easy-dotnet").build_quickfix() end, desc = "build solution" },
      { "<leader>nr", function() require("easy-dotnet").run_default() end, desc = "run" },
      { "<leader>nR", function() require("easy-dotnet").run_solution() end, desc = "run solution" },
      { "<leader>nx", function() require("easy-dotnet").clean() end, desc = "clean solution" },
      { "<leader>na", "<cmd>Dotnet new<cr>", desc = "new item" },
      { "<leader>nt", "<cmd>Dotnet testrunner<cr>", desc = "open test runner" },
			-- stylua: ignore end
		},
	},
}
