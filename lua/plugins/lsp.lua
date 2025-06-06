return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			-- Plugin(s) and UI to automatically install LSPs to stdpath
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Progress/Status update for LSP
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local mason = require("mason")
			local mason_tool_installer = require("mason-tool-installer")
			local mason_lspconfig = require("mason-lspconfig")
			local map_lsp_keybinds = require("treramey.keymaps").map_lsp_keybinds -- Has to load keymaps before plugins lsp

			-- -- Default handlers for LSP
			-- local default_handlers = {
			-- 	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
			-- 	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			-- }

			local vtsls_inlay_hints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
			}

			-- Function to run when neovim connects to a Lsp client
			---@diagnostic disable-next-line: unused-local
			local on_attach = function(_client, buffer_number)
				-- Pass the current buffer to map lsp keybinds
				map_lsp_keybinds(buffer_number)
			end

			local util = require("lspconfig/util")

			local configs = require("lspconfig.configs")

			if not configs["harper-ls"] then
				configs["harper-ls"] = {
					default_config = {
						cmd = { "harper-ls", "--stdio" },
						filetypes = { "markdown", "text" },
						root_dir = util.root_pattern(".git"),
						single_file_support = true,
					},
				}
			end

			local servers = {
				-- LSP Servers
				astro = {},
				bashls = {},
				biome = {},
				cssls = {
					settings = {
						css = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
				},
				gleam = {
					settings = {
						inlayHints = true,
					},
				},
				eslint = {
					autostart = false,
					cmd = { "vscode-eslint-language-server", "--stdio", "--max-old-space-size=12288" },
					settings = {
						format = false,
					},
				},
				["harper-ls"] = {},
				html = {},
				jsonls = {},
				gopls = {
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = util.root_pattern("go.work", "go.mod", ".git"),
					settings = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								-- lazydev.nvim will handle library configuration
							},
							telemetry = { enabled = false },
						},
					},
				},
				marksman = {},
				nil_ls = {},
				pyright = {},
				sqlls = {},
				svelte = {},
				tailwindcss = {},
				vtsls = {
					on_attach = function(client, buffer_number)
						require("twoslash-queries").attach(client, buffer_number)
						return on_attach(client, buffer_number)
					end,
					settings = {
						maxTsServerMemory = 12288,
						typescript = { inlayHints = vtsls_inlay_hints },
						javascript = { inlayHints = vtsls_inlay_hints },
					},
				},
				yamlls = {},
			}

			local formatters = {
				prettierd = {},
				stylua = {},
				goimports = {},
				csharpier = {},
				xmlformatter = {},
			}

			local other_tools = {
				netcoredbg = {},
				rustywind = {},
			}

			local manually_installed_servers = { "gleam" }

			local mason_tools_to_install =
				vim.tbl_keys(vim.tbl_deep_extend("force", {}, servers, formatters, other_tools))

			local ensure_installed = vim.tbl_filter(function(name)
				return not vim.tbl_contains(manually_installed_servers, name)
			end, mason_tools_to_install)

			mason_tool_installer.setup({
				auto_update = true,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 12,
				ensure_installed = ensure_installed,
			})

			-- Iterate over our servers and set them up
			for name, config in pairs(servers) do
				local capabilities = require("blink.cmp").get_lsp_capabilities({})
				require("lspconfig")[name].setup({
					cmd = config.cmd,
					capabilities = capabilities,
					filetypes = config.filetypes,
					handlers = vim.tbl_deep_extend("force", {}, config.handlers or {}),
					autostart = config.autostart,
					on_attach = on_attach,
					settings = config.settings,
					root_dir = config.root_dir,
				})
			end

			-- Setup mason so it can manage 3rd party LSP servers
			mason.setup({
				max_concurrent_installers = 10,
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "",
					},
					border = "single",
				},
				registries = {
					"github:mason-org/mason-registry",
					"github:syndim/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})

			mason_lspconfig.setup({
				ensure_installed = {},
				automatic_installation = true,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			-- Configure border for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"
		end,
	},
	{ --ohhh the pain
		"treramey/cfmlsp.nvim",
		event = { "BufReadPre", "BufReadPost", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = function()
			local map_lsp_keybinds = require("treramey.keymaps").map_lsp_keybinds
			return {
				on_attach = function(_, bufnr)
					map_lsp_keybinds(bufnr)
				end,
			}
		end,
	},
}
