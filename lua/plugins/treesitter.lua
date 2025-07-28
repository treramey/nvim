return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			---@diagnostic disable: missing-fields
			---@class ParserInfo
			local parserConfig = require("nvim-treesitter.parsers").get_parser_configs()
			-- Add cfml and boxlang filetypes
			vim.filetype.add({
				extension = {
					cfm = "cfml",
					cfc = "cfml",
					cfs = "cfml",
					bxm = "boxlang",
					bx = "boxlang",
					bxs = "boxlang",
				},
			})

			-- Setup syntax highlighting
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.cfm", "*.cfc", "*.cfs", "*.bxm", "*.bx", "*.bxs" },
				callback = function()
					vim.cmd("setlocal syntax=cf")
					vim.o.signcolumn = "yes"
				end,
			})
			parserConfig.cfml = {
				install_info = {
					url = "https://github.com/cfmleditor/tree-sitter-cfml",
					files = { "src/parser.c", "src/scanner.c" },
					location = "cfml",
				},
				filetype = "cfml", -- Filetype in Neovim to associate with the parser,
				maintainers = { "@ghedwards" },
			}

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"css",
					"cfml",
					"go",
					"c_sharp",
					"html",
					"javascript",
					"json",
					"latex",
					"lua",
					"markdown",
					"markdown_inline",
					"norg",
					"regex",
					"rust",
					"scss",
					"tsx",
					"typescript",
					"typst",
					"vue",
					"yaml",
				},
				auto_install = true,
				sync_install = false,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
					disable = { "ocaml", "ocaml_interface" },
				},
				autopairs = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<c-backspace>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
	{
		-- Additional text objects for treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local tsc = require("treesitter-context")
			tsc.setup({
				enable = false,
				max_lines = 1,
				trim_scope = "inner",
			})
		end,
	},
}
