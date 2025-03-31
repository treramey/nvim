return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"jmacadie/telescope-hierarchy.nvim",
			"polarmutex/git-worktree.nvim",
		},

		config = function()
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<C-x>"] = actions.delete_buffer,
						},
						n = {
							["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						},
					},
					file_ignore_patterns = {
						"node_modules",
						"yarn.lock",
						".git",
						".sl",
						"_build",
						".next",
						".undodir",
						"bin",
						"obj",
					},
					hidden = true,
					path_display = {
						"filename_first",
					},
				},
			})

			-- Enable telescope fzf native, if installed
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("hierarchy")
		end,
	},
}
