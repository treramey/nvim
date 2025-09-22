return {
	"polarmutex/git-worktree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim",
	},
	config = function()
		vim.g.git_worktree = {
			change_directory_command = "cd",
			update_on_change = true,
			update_on_change_command = "e .",
			clearjumps_on_change = true,
			autopush = false,
		}

		local Hooks = require("git-worktree.hooks")
		Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
	end,
	keys = {
		{
			"<leader>gt",
			function()
				local function get_branches()
					local branches = {}
					local handle = io.popen("git branch -r --format='%(refname:short)' | grep -v HEAD")
					if handle then
						for line in handle:lines() do
							local branch = line:gsub("origin/", "")
							if branch ~= "origin" and branch ~= "" then
								table.insert(branches, {
									text = branch,
									value = branch,
								})
							end
						end
						handle:close()
					end

					-- Add option to create new branch
					table.insert(branches, 1, {
						text = "Create New Branch",
						value = "create_new",
					})
					return branches
				end

				local snacks = require("snacks")
				local branches = get_branches()
				local items = {}
				for _, branch in ipairs(branches) do
					table.insert(items, branch.text)
				end

				snacks.picker.select(items, {
					prompt = "Create Worktree from Branch:",
				}, function(choice)
					if not choice then
						return
					end

					local git_worktree = require("git-worktree")
					if choice == "Create New Branch" then
						-- Create new branch
						local branch = vim.fn.input("New branch name: ")
						if branch and branch ~= "" then
							local git_common_dir = vim.fn.systemlist("git rev-parse --git-common-dir")[1]
							local git_root = vim.fn.fnamemodify(git_common_dir, ":h")
							local default_path = git_root .. "/" .. branch
							local path = vim.fn.input("Path (default: " .. default_path .. "): ")
							if path == "" then
								path = default_path
							end
							local ok, err = pcall(git_worktree.create_worktree, path, branch, "origin/" .. branch)
							if not ok then
								vim.notify("Failed to create worktree: " .. tostring(err), vim.log.levels.ERROR)
							else
								vim.notify("Created worktree: " .. path, vim.log.levels.INFO)
							end
						end
					else
						-- Use existing branch
						local git_common_dir = vim.fn.systemlist("git rev-parse --git-common-dir")[1]
						local git_root = vim.fn.fnamemodify(git_common_dir, ":h")
						local default_path = git_root .. "/" .. choice
						local path = vim.fn.input("Path (default: " .. default_path .. "): ")
						if path == "" then
							path = default_path
						end
						local ok, err = pcall(git_worktree.create_worktree, path, choice, "origin/" .. choice)
						if not ok then
							vim.notify("Failed to create worktree: " .. tostring(err), vim.log.levels.ERROR)
						else
							vim.notify("Created worktree: " .. path, vim.log.levels.INFO)
						end
					end
				end)
			end,
			desc = "Create worktree from origin or new branch",
		},
		{
			"<leader>gw",
			function()
				local function get_worktrees()
					local worktrees = {}
					local handle = io.popen("git worktree list")
					if handle then
						for line in handle:lines() do
							local path = line:match("^([^%s]+)")
							local branch = line:match("%[([^%]]+)%]")
							if path and branch then
								table.insert(worktrees, {
									text = branch .. " (" .. path .. ")",
									value = path,
									branch = branch,
									path = path,
								})
							end
						end
						handle:close()
					end
					return worktrees
				end

				local snacks = require("snacks")
				local worktrees = get_worktrees()
				local items = {}
				for _, wt in ipairs(worktrees) do
					table.insert(items, wt.text)
				end

				snacks.picker.select(items, {
					prompt = "Switch Git Worktree:",
				}, function(choice)
					if not choice then
						return
					end

					-- Find the worktree that matches the display choice
					for _, wt in ipairs(worktrees) do
						if wt.text == choice then
							local git_worktree = require("git-worktree")
							git_worktree.switch_worktree(wt.value)
							break
						end
					end
				end)
			end,
			desc = "Switch Git Worktree",
		},
		{
			"<leader>gd",
			function()
				local function get_worktrees()
					local worktrees = {}
					local handle = io.popen("git worktree list")
					if handle then
						for line in handle:lines() do
							local path = line:match("^([^%s]+)")
							local branch = line:match("%[([^%]]+)%]")
							if path and branch and branch ~= "main" and branch ~= "master" then
								table.insert(worktrees, {
									text = branch .. " (" .. path .. ")",
									value = path,
									branch = branch,
									path = path,
								})
							end
						end
						handle:close()
					end
					return worktrees
				end

				local worktrees = get_worktrees()
				if #worktrees == 0 then
					vim.notify("No worktrees available for deletion", vim.log.levels.INFO)
					return
				end

				local snacks = require("snacks")
				local items = {}
				for _, wt in ipairs(worktrees) do
					table.insert(items, wt.text)
				end

				snacks.picker.select(items, {
					prompt = "Delete Git Worktree:",
				}, function(choice)
					if not choice then
						return
					end

					-- Find the worktree that matches the display choice
					for _, wt in ipairs(worktrees) do
						if wt.text == choice then
							local git_worktree = require("git-worktree")
							git_worktree.delete_worktree(wt.value)
							break
						end
					end
				end)
			end,
			desc = "Delete Git Worktree",
		},
	},
}
