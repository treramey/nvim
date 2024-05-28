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
		config = function()
			local actions = require("telescope.actions")
			local colors = require("catppuccin.palettes").get_palette("macchiato")

			local macchiato = "#24273a"

			local TelescopeColor = {
				TelescopeMatching = { fg = colors.flamingo },
				TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

				TelescopePromptPrefix = { bg = colors.surface0 },
				TelescopePromptNormal = { bg = colors.surface0 },
				TelescopeResultsNormal = { bg = macchiato },
				TelescopePreviewNormal = { bg = macchiato },
				TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
				TelescopeResultsBorder = { bg = macchiato, fg = macchiato },
				TelescopePreviewBorder = { bg = macchiato, fg = macchiato },
				TelescopePromptTitle = { bg = colors.surface0, fg = colors.surface0 },
				TelescopeResultsTitle = { fg = colors.mauve },
				TelescopePreviewTitle = { bg = colors.green, fg = macchiato },
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
