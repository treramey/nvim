return {
  --[[
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
      extensions = {
        razor = { enabled = false },
      },
    },
    init = function()
      -- Roslyn LSP + mise setup
      --
      -- Mise (isolated=false) keeps all .NET SDKs under a single DOTNET_ROOT at
      -- ~/.local/share/mise/dotnet-root/, so net8/9/10 targeting packs live there.
      --
      -- DOTNET_ROOT is set in cmd_env so Roslyn still resolves the SDK when nvim
      -- is launched outside a mise-activated shell. DOTNET_ROOT_X64 works around
      -- the .NET 10 muxer bug (dotnet/sdk#51693) where subprocesses resolve the
      -- SDK root relative to their binary path and ignore DOTNET_ROOT.
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
  --]]
  {
    "GustavEikaas/easy-dotnet.nvim",
    enabled = function()
      return vim.fn.executable("dotnet") == 1
    end,
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim", "j-hui/fidget.nvim" },
    cmd = "Dotnet",
    event = "VeryLazy",
    config = function()
      require("treramey.dotnet").setup_easy_dotnet()
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
