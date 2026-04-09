return {
  {
    "seblyng/roslyn.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "j-hui/fidget.nvim",
    },
    enabled = function()
      return vim.fn.executable("dotnet") == 1
    end,
    opts = {
      broad_search = true,
      silent = true,
    },
    init = function()
      -- Roslyn LSP + mise workaround
      --
      -- Problem: mise installs each .NET SDK in isolation (~/.local/share/mise/installs/dotnet/<ver>/).
      -- The Roslyn LS binary (Mason) is compiled for net10.0, so it needs the .NET 10 runtime.
      -- But projects targeting net9.0 need net9.0 targeting packs (Microsoft.NETCore.App.Ref,
      -- Microsoft.AspNetCore.App.Ref) which only exist in the .NET 9 SDK install.
      --
      -- Additionally, .NET 10 has a muxer bug (dotnet/sdk#51693) where subprocesses resolve
      -- their SDK root relative to their binary path, ignoring DOTNET_ROOT. Setting
      -- DOTNET_ROOT_X64 works around this.
      --
      -- Fix (3 parts):
      --   1. DOTNET_ROOT + DOTNET_ROOT_X64 → dotnet/10 so Roslyn can start
      --   2. Set rollForward: "latestMajor" in project global.json so 10.x SDK resolves 9.x projects
      --
      -- See: dotnet/sdk#51693, NixOS/nixpkgs#464575, roslyn.nvim#293
      local mise_dotnet_root = vim.fn.expand("~/.local/share/mise/dotnet-root")
      vim.lsp.config("roslyn", {
        cmd_env = {
          Configuration = vim.env.Configuration or "Debug",
          DOTNET_ROOT = mise_dotnet_root,
          DOTNET_ROOT_X64 = mise_dotnet_root,
          PATH = mise_dotnet_root .. ":" .. vim.env.PATH,
          TMPDIR = vim.env.TMPDIR and vim.fn.resolve(vim.env.TMPDIR) or nil,
        },
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })

      local restore_handles = {}
      vim.api.nvim_create_autocmd("User", {
        pattern = "RoslynRestoreProgress",
        callback = function(ev)
          local token = ev.data.params[1]
          if not restore_handles[token] then
            restore_handles[token] = require("fidget.progress").handle.create({
              title = ev.data.params[2].state,
              message = ev.data.params[2].message,
              lsp_client = { name = "roslyn" },
            })
          else
            restore_handles[token]:report({
              title = ev.data.params[2].state,
              message = ev.data.params[2].message,
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "RoslynRestoreResult",
        callback = function(ev)
          local handle = restore_handles[ev.data.token]
          if handle then
            handle.message = ev.data.err and ev.data.err.message or "Restore completed"
            handle:finish()
            restore_handles[ev.data.token] = nil
          end
        end,
      })

      local init_handles = {}
      vim.api.nvim_create_autocmd("User", {
        pattern = "RoslynOnInit",
        callback = function(ev)
          init_handles[ev.data.client_id] = require("fidget.progress").handle.create({
            title = "Initializing Roslyn",
            message = ev.data.type == "solution" and string.format("Initializing Roslyn for %s", ev.data.target)
              or "Initializing Roslyn for project",
            lsp_client = { name = "roslyn" },
          })
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local handle = init_handles[args.data.client_id]
          if handle then
            handle:finish()
            init_handles[args.data.client_id] = nil
          end
        end,
      })
    end,
    lazy = false,
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    enabled = function()
      return vim.fn.executable("dotnet") == 1
    end,
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim", "j-hui/fidget.nvim" },
    cmd = "Dotnet",
    event = "VeryLazy",
    config = function()
      local dotnet = require("easy-dotnet")

      local bin_path = vim.fn.stdpath("data") .. "/lazy/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg"

      if vim.fn.has("win32") == 1 then
        bin_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg.exe"
      elseif not (vim.fn.has("macunix") == 1 and vim.fn.has("arm64") == 1) then
        bin_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
      end

      if vim.fn.executable(bin_path) ~= 1 then
        vim.notify("[easy-dotnet] Debugger binary not found: " .. bin_path, vim.log.levels.WARN)
      end

      local parsers = require("easy-dotnet.parsers")

      local function find_project_path()
        return parsers.sln_parser.find_solution_file() or parsers.csproj_parser.find_project_file()
      end

      dotnet.setup({
        picker = "snacks",
        debugger = {
          bin_path = bin_path,
          mappings = { open_variable_viewer = { lhs = "T", desc = "open variable viewer" } },
          apply_value_converters = true,
        },
        lsp = {
          enabled = false,
          roslynator_enabled = false,
        },
        notifications = {
          handler = function(start_event)
            local handle = require("fidget.progress").handle.create({
              title = start_event.job.name,
              message = "Running...",
              lsp_client = { name = "easy-dotnet" },
            })
            return function(finished_event)
              if handle then
                handle.message = finished_event.result.msg
                handle:finish()
              end
            end
          end,
        },
        terminal = function(path, action, args)
          args = args or ""
          -- stylua: ignore
          local commands = {
            run = function() return string.format("dotnet run --project %s %s", path, args) end,
            test = function() return string.format("dotnet test %s %s", path, args) end,
            restore = function() return string.format("dotnet restore %s %s", path, args) end,
            build = function() return string.format("dotnet build %s %s", path, args) end,
            watch = function() return string.format("dotnet watch --project %s %s", path, args) end,
          }
          Snacks.terminal.toggle(commands[action](), { win = { position = "bottom", height = 0.35 } })
        end,
        auto_bootstrap_namespace = { type = "file_scoped", enabled = true },
        test_runner = { viewmode = "vsplit", vsplit_width = 70, icons = { project = "󰗀" } },
      })

      vim.api.nvim_create_user_command("DotnetListPackages", function()
        local path = find_project_path() or "."
        Snacks.terminal.toggle("dotnet list " .. path .. " package --include-transitive; read", {
          win = { style = "float", width = 0.8, height = 0.8, border = "rounded" },
        })
      end, { desc = "List packages with transitive deps" })

      vim.api.nvim_create_user_command("DotnetLaunchSettings", function()
        local files = vim.fs.find("launchSettings.json", { type = "file", limit = math.huge })
        if #files == 0 then
          vim.notify("[easy-dotnet] No launchSettings.json found", vim.log.levels.WARN)
        elseif #files == 1 then
          vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
        else
          vim.ui.select(files, { prompt = "Select launchSettings.json" }, function(choice)
            if choice then
              vim.cmd("edit " .. vim.fn.fnameescape(choice))
            end
          end)
        end
      end, { desc = "Open launchSettings.json" })
    end,
    keys = {
      -- stylua: ignore start
      { "<leader>nw", "<cmd>Dotnet watch<cr>", desc = "watch solution" },
      { "<leader>nb", "<cmd>Dotnet build quickfix<cr>", desc = "build quickfix" },
      { "<leader>nB", "<cmd>Dotnet build<cr>", desc = "build" },
      { "<leader>nr", "<cmd>Dotnet restore<cr>", desc = "restore packages" },
      { "<leader>nQ", "<cmd>Dotnet build solution quickfix<cr>", desc = "build solution quickfix" },
      { "<leader>nR", "<cmd>Dotnet run solution<cr>", desc = "run solution" },
      { "<leader>nx", "<cmd>Dotnet clean<cr>", desc = "clean solution" },
      { "<leader>nn", "<cmd>Dotnet<cr>", desc = "open dotnet menu" },
      { "<leader>na", "<cmd>Dotnet new<cr>", desc = "new item" },
      { "<leader>nt", "<cmd>Dotnet testrunner<cr>", desc = "open test runner" },
      { "<leader>np", "<cmd>DotnetListPackages<cr>", desc = "list packages" },
      { "<leader>ns", "<cmd>DotnetLaunchSettings<cr>", desc = "open launchSettings.json" },
      -- stylua: ignore end
    },
  },
}
