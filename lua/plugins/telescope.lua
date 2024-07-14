return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				cond = vim.fn.executable("cmake") == 1,
			},
		},
		keys = {
			-- Show help actions with telescope
			{
				"<leader>ad",
				function()
					local actions = require("CopilotChat.actions")
					local help = actions.help_actions()
					if not help then
						vim.notify("No diagnostics found on the current line", "warn", { title = "Copilot Chat" })
						return
					end
					require("CopilotChat.integrations.telescope").pick(help)
				end,
				desc = "Diagnostic Help (CopilotChat)",
				mode = { "n", "v" },
			},
			-- Show prompts actions with telescope
			{
				"<leader>ap",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				desc = "Prompt Actions (CopilotChat)",
				mode = { "n", "v" },
			},
		},

		config = function()
			local actions = require("telescope.actions")
			local macchiato = require("catppuccin.palettes").get_palette("macchiato")

			local background = "#24273a"

			local TelescopeColor = {
				TelescopeMatching = { fg = macchiato.flamingo },
				-- TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

				TelescopePromptPrefix = { bg = background },
				TelescopePromptNormal = { bg = background },
				TelescopeResultsNormal = { bg = background },
				TelescopePreviewNormal = { bg = background },
				TelescopePromptBorder = { bg = background, fg = macchiato.mauve },
				TelescopeResultsBorder = { bg = background, fg = macchiato.mauve },
				TelescopePreviewBorder = { bg = background, fg = macchiato.mauve },
				TelescopePromptTitle = { bg = background, fg = macchiato.mauve },
				TelescopeResultsTitle = { bg = background, fg = macchiato.mauve },
				TelescopePreviewTitle = { bg = background, fg = macchiato.mauve },
			}

			for hl, col in pairs(TelescopeColor) do
				vim.api.nvim_set_hl(0, hl, col)
			end

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-x>"] = actions.delete_buffer,
						},
					},
					file_ignore_patterns = {
						"node_modules",
						"yarn.lock",
						".git",
						".sl",
						"_build",
						".next",
					},
					hidden = true,
					path_display = {
						"filename_first",
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")
		end,
	},
}
