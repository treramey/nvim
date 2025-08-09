return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			-- LSP installer plugins
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
			-- Progress indicator for LSP
			{ "j-hui/fidget.nvim" },
		},
		config = function()
			local mason = require("mason")
			local mason_tool_installer = require("mason-tool-installer")
			local mason_lspconfig = require("mason-lspconfig")
			local map_lsp_keybinds = require("treramey.keymaps").map_lsp_keybinds -- Has to load keymaps before plugins lsp

			local vtsls_inlay_hints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				functionParameterTypes = { enabled = true },
				parameterNames = { enabled = "all" },
				parameterNameWhenArgumentMatchesNames = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = true },
				variableTypeWhenTypeMatchesNames = { enabled = true },
			}

			local on_attach = function(_client, buffer_number)
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
				bashls = {},
				biome = {},
				cssls = {},
				gleam = {
					settings = {
						inlayHints = true,
					},
				},
				eslint = {
					autostart = false,
					cmd = { "vscode-eslint-language-server", "--stdio", "--max-old-space-size=12288" },
					settings = { format = false },
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
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							telemetry = { enabled = false },
						},
					},
				},
				marksman = {},
				nil_ls = {},
				pyright = {},
				rust_analyzer = {
					check = { command = "clippy", features = "all" },
				},
				sqlls = {},
				svelte = {},
				tailwindcss = {
					filetypes = { "typescriptreact", "javascriptreact", "html", "svelte" },
				},
				vtsls = {
					on_attach = function(client, buffer_number)
						require("twoslash-queries").attach(client, buffer_number)
						return on_attach(client, buffer_number)
					end,
					settings = {
						complete_function_calls = true,
						vtsls = {
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							tsserver = {
								maxTsServerMemory = 12288,
							},
							inlayHints = vtsls_inlay_hints,
						},
						javascript = { inlayHints = vtsls_inlay_hints },
					},
				},
				yamlls = {},
			}

			local formatters = {
				biome = {},
				prettierd = {},
				prettier = {},
				stylua = {},
				goimports = {},
				csharpier = {},
			}

			local other_tools = {
				netcoredbg = {},
				rustywind = {},
			}

			local manually_installed_servers = { "gleam", "rust_analyzer" }

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

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Setup each LSP server. We merge in any server-specific capabilities by passing
			-- the existing config.capabilities to blink.cmp.get_lsp_capabilities.
			for name, config in pairs(servers) do
				require("lspconfig")[name].setup({
					autostart = config.autostart,
					cmd = config.cmd,
					capabilities = capabilities,
					filetypes = config.filetypes,
					handlers = vim.tbl_deep_extend("force", {}, config.handlers or {}),
					on_attach = config.on_attach or on_attach,
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
					"github:Crashdummyy/mason-registry",
				},
			})

			mason_lspconfig.setup()

			-- Configure border for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Note: borders are configured per-function in keymaps.lua
		end,
	},
	{ --ohhh the pain
		"treramey/cfmlsp.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
