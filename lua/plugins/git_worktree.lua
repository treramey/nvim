return {
  "polarmutex/git-worktree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  config = function()
    vim.g.git_worktree = {
      change_directory_command = "cd",
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
        local branches = {}
        local lines = vim.fn.systemlist("git branch -r --format='%(refname:short)'")
        for _, line in ipairs(lines) do
          if not line:match("HEAD") then
            local branch = line:gsub("^origin/", "")
            if branch ~= "origin" and branch ~= "" then
              table.insert(branches, branch)
            end
          end
        end

        table.insert(branches, 1, "Create New Branch")

        local snacks = require("snacks")
        snacks.picker.select(branches, {
          prompt = "Create Worktree from Branch:",
        }, function(choice)
          if not choice then
            return
          end

          local branch, upstream
          if choice == "Create New Branch" then
            branch = vim.fn.input("New branch name: ")
            if not branch or branch == "" then
              return
            end
            upstream = "HEAD"
          else
            branch = choice
            upstream = "origin/" .. choice
          end

          local git_common_dir = vim.fn.systemlist("git rev-parse --git-common-dir")[1]
          local git_root = vim.fn.fnamemodify(git_common_dir, ":h")
          local default_path = git_root .. "/" .. branch
          local path = vim.fn.input("Path (default: " .. default_path .. "): ")
          if path == "" then
            path = default_path
          end

          local git_worktree = require("git-worktree")
          local ok, err = pcall(git_worktree.create_worktree, path, branch, upstream)
          if not ok then
            vim.notify("Failed to create worktree: " .. tostring(err), vim.log.levels.ERROR)
          else
            vim.notify("Created worktree: " .. path, vim.log.levels.INFO)
          end
        end)
      end,
      desc = "Create worktree from origin or new branch",
    },
    {
      "<leader>gw",
      function()
        local worktrees = {}
        local lines = vim.fn.systemlist("git worktree list --porcelain")

        local current = {}
        for _, line in ipairs(lines) do
          if line:match("^worktree ") then
            current = { path = line:match("^worktree (.+)") }
          elseif line:match("^branch ") then
            current.branch = line:match("^branch refs/heads/(.+)")
            if current.path and current.branch then
              table.insert(worktrees, current)
            end
          end
        end

        if #worktrees == 0 then
          vim.notify("No worktrees found", vim.log.levels.INFO)
          return
        end

        local items = {}
        for _, wt in ipairs(worktrees) do
          table.insert(items, wt.branch .. " (" .. wt.path .. ")")
        end

        local snacks = require("snacks")
        snacks.picker.select(items, {
          prompt = "Switch Git Worktree:",
        }, function(_, idx)
          if not idx then
            return
          end

          local wt = worktrees[idx]
          local git_worktree = require("git-worktree")
          git_worktree.switch_worktree(wt.path)
        end)
      end,
      desc = "Switch Git Worktree",
    },
  },
}
