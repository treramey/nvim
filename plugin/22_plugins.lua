local add = vim.pack.add
local gh, now, now_if_args, later = Config.gh, Config.now, Config.now_if_args, Config.later

local delete_inactive_plugins = function()
  local inactive = vim.iter(vim.pack.get())
    :filter(function(plugin)
      return not plugin.active
    end)
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable()

  if #inactive > 0 then
    vim.pack.del(inactive)
  end
end

local update_plugins = function(opts)
  if #opts.fargs == 0 then
    delete_inactive_plugins()
  end

  local names = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(names, { force = opts.bang })
end

local complete_plugins = function()
  return vim.tbl_map(function(plugin)
    return plugin.spec.name
  end, vim.tbl_filter(function(plugin)
    return plugin.active
  end, vim.pack.get()))
end

pcall(vim.api.nvim_del_user_command, "UpdatePlugins")
vim.api.nvim_create_user_command("UpdatePlugins", update_plugins, {
  bang = true,
  complete = complete_plugins,
  desc = "Update vim.pack plugins. Use ! to skip confirmation.",
  nargs = "*",
})

-- ─[ load at startup ]────────────────────────────────────────────────────
now(function()
  local ts_update = function()
    vim.cmd "TSUpdate"
  end
  Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

  add {
    gh "nvim-treesitter/nvim-treesitter",
    gh "nvim-treesitter/nvim-treesitter-textobjects",
  }

  local languages = {
    "bash",
    "c_sharp",
    "comment",
    "css",
    "dockerfile",
    "editorconfig",
    "git_config",
    "gitattributes",
    "gitignore",
    "html",
    "go",
    "javascript",
    "jsdoc",
    "json",
    "jsx",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "nginx",
    "nix",
    "query",
    "regex",
    "rust",
    "powershell",
    "svelte",
    "tmux",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zsh",
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
  end
  Config.new_autocmd("FileType", filetypes, ts_start, "Start tree-sitter")
end)

now_if_args(function()
  add {
    gh "neovim/nvim-lspconfig",
    gh "mason-org/mason.nvim",
    gh "mason-org/mason-lspconfig.nvim",
    gh "WhoIsSethDaniel/mason-tool-installer.nvim",
  }

  local servers = {
    "bashls",
    "biome",
    "copilot",
    "cssls",
    "eslint",
    "emmylua_ls",
    "gopls",
    "html",
    "marksman",
    "oxfmt",
    "oxlint",
    "roslyn_ls",
    "rust_analyzer",
    "svelte",
    "tailwindcss",
    "taplo",
    "vtsls",
    "yamlls",
  }
  local mason_tools = vim.tbl_filter(function(server)
    return server ~= "roslyn_ls"
  end, servers)

  require("mason").setup {
    max_concurrent_installers = 10,
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry",
    },
    ui = {
      border = "single",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "",
      },
    },
  }

  require("mason-lspconfig").setup { automatic_enable = false }
  require("mason-tool-installer").setup {
    auto_update = true,
    debounce_hours = 12,
    ensure_installed = mason_tools,
    run_on_start = true,
    start_delay = 3000,
  }

  -- The latest Roslyn tool targets .NET 10. Keep its host runtime independent
  -- from projects that pin an older SDK through mise.
  local dotnet_10_root = vim.fn.expand "$HOME/.local/share/mise/installs/dotnet/10"
  local roslyn_tool = vim.fn.expand "$HOME/.dotnet/tools/roslyn-language-server"
  vim.lsp.config("roslyn_ls", {
    cmd = {
      "env",
      "-u",
      "__MISE_SHIM",
      "DOTNET_ROOT=" .. dotnet_10_root,
      "DOTNET_ROOT_X64=" .. dotnet_10_root,
      "PATH=" .. dotnet_10_root .. ":" .. vim.env.PATH,
      roslyn_tool,
      "--stdio",
    },
    cmd_env = {
      DOTNET_ROOT = dotnet_10_root,
      DOTNET_ROOT_X64 = dotnet_10_root,
      PATH = dotnet_10_root .. ":" .. vim.env.PATH,
    },
  })

  vim.lsp.enable(servers)

  vim.lsp.inline_completion.enable()
end)

-- ─[ load if opened with file ]───────────────────────────────────────────
now_if_args(function()
  add { gh "rafamadriz/friendly-snippets" }
end)

-- lazydev.nvim removed — Neovim 0.12's vim.func replaces it

-- ─[ lazy load ]────────────────────────────────────────────────────
-- sidekick.nvim removed
-- colorful-winsep.nvim removed

later(function()
  add { gh "dmmulroy/ts-error-translator.nvim" }
  require("ts-error-translator").setup()
end)

later(function()
  add { gh "mrjones2014/smart-splits.nvim" }
end)

later(function()
  add { gh "windwp/nvim-ts-autotag" }
  require("nvim-ts-autotag").setup()
end)
