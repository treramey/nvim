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
      "saghen/blink.cmp",
    },
    config = function()
      local mason = require("mason")
      local mason_tool_installer = require("mason-tool-installer")
      local mason_lspconfig = require("mason-lspconfig")
      local map_lsp_keybinds = require("treramey.keymaps").map_lsp_keybinds -- Has to load keymaps before plugins lsp

      local servers = {
        -- LSP Servers
        bashls = {},
        biome = {},
        cssls = {},
        eslint = {
          autostart = false,
          cmd = { "vscode-eslint-language-server", "--stdio", "--max-old-space-size=12288" },
          settings = { format = false },
        },
        ["harper-ls"] = {
          cmd = { "harper-ls", "--stdio" },
          filetypes = { "markdown", "text" },
          root_markers = { ".git" },
        },
        ["copilot-language-server"] = {
          cmd = { "copilot-language-server", "--stdio" },
        },
        html = {},
        jsonls = {},
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_markers = { "go.work", "go.mod", ".git" },
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
        oxlint = {
          root_markers = { ".oxlintrc.json" },
        },
        marksman = {},
        pyright = {},
        rust_analyzer = {
          check = { command = "clippy", features = "all" },
        },
        sqls = {},
        svelte = {},
        tailwindcss = {
          filetypes = { "typescriptreact", "javascriptreact", "html", "svelte" },
        },
        yamlls = {},
      }

      local formatters = {
        biome = {},
        prettierd = {},
        prettier = {},
        stylua = {},
        goimports = {},
        xmlformatter = {},
        sleek = {},
      }

      local other_tools = {
        netcoredbg = {},
        rustywind = {},
        roslyn = {},
      }

      local manually_installed_servers = {}

      local mason_tools_to_install = vim.tbl_keys(vim.tbl_deep_extend("force", {}, servers, formatters, other_tools))

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

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local bufname = vim.api.nvim_buf_get_name(bufnr)

          -- Detach from non-file buffers (diffview, fugitive, etc.)
          if bufname == "" or bufname:match("^diffview://") or bufname:match("^fugitive://") then
            vim.schedule(function()
              vim.lsp.buf_detach_client(bufnr, event.data.client_id)
            end)
            return
          end

          map_lsp_keybinds(bufnr)
        end,
      })

      for name, config in pairs(servers) do
        local autostart = config.autostart
        config.autostart = nil
        vim.lsp.config(name, config)

        if autostart ~= false then
          vim.lsp.enable(name)
        end
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

      -- Enable inline completion if available (Neovim 0.11+)
      if vim.lsp.inline_completion then
        vim.lsp.inline_completion.enable()
      end
    end,
  },
}
