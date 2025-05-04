return {
	"polarmutex/git-worktree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("telescope").load_extension("git_worktree")
	end,
	init = function()
		vim.g.git_worktree = {
			change_directory_command = "cd",
			update_on_change = false,
			update_on_change_command = "e .",
			clearjumps_on_change = true,
			confirm_telescope_deletions = true,
			autopush = false,
		}

		local Hooks = require("git-worktree.hooks")
		Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
	end,
	keys = {
		{
			"<leader>gW",
			function()
				local branch = vim.fn.input("Branch: ")
				local path = vim.fn.input("Path: ")
				if path == "" then
					path = "../" .. branch
				end
				require("git-worktree").create_worktree(path, branch, "origin")
			end,
			desc = "Create a new worktree",
		},
		{
			"<leader>gw",
			function()
				require("telescope").extensions.git_worktree.git_worktree()
			end,
			desc = "[Telescope] Switch Git Worktree",
		},
		{
			"<leader>gt",
			function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end,
			desc = "[Telescope] Create Git Worktree",
		},
	},
}
