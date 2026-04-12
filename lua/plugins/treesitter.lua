return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    cmd = { "TSUpdate" },
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Register CFML parser
      local parsers = require("nvim-treesitter.parsers")
      if not parsers.cfml then
        parsers.cfml = {
          install_info = {
            url = "https://github.com/cfmleditor/tree-sitter-cfml",
            files = { "cfml/src/parser.c", "cfml/src/scanner.c" },
            location = "cfml",
            revision = "master",
          },
          filetype = "cfml",
          tier = 3,
        }
      end

      vim.filetype.add({
        extension = {
          jsonc = "json",
        },
      })

      local lang = {
        "bash",
        "c",
        "css",
        "go",
        "python",
        "c_sharp",
        "html",
        "javascript",
        "json",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "regex",
        "rust",
        "scss",
        "svelte",
        "tsx",
        "typescript",
        "typst",
        "yaml",
        "dockerfile",
        "make",
        "java",
        "php",
        "ruby",
        "sql",
        "toml",
        "razor",
        "bicep",
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = table.concat(lang, ","),
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          vim.defer_fn(function()
            require("nvim-treesitter").install(lang)
          end, 100)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local sel = require("nvim-treesitter-textobjects.select").select_textobject
      local mov = require("nvim-treesitter-textobjects.move")

      for _, m in ipairs({
        { "aa", "@parameter.outer" },
        { "ia", "@parameter.inner" },
        { "af", "@function.outer" },
        { "if", "@function.inner" },
        { "ac", "@class.outer" },
        { "ic", "@class.inner" },
      }) do
        vim.keymap.set({ "o", "x" }, m[1], function()
          sel(m[2])
        end)
      end

      for _, m in ipairs({
        { "]m", "goto_next_start", "@function.outer" },
        { "]M", "goto_next_end", "@function.outer" },
        { "]]", "goto_next_start", "@class.outer" },
        { "][", "goto_next_end", "@class.outer" },
        { "[m", "goto_previous_start", "@function.outer" },
        { "[M", "goto_previous_end", "@function.outer" },
        { "[[", "goto_previous_start", "@class.outer" },
        { "[]", "goto_previous_end", "@class.outer" },
      }) do
        vim.keymap.set({ "n", "x", "o" }, m[1], function()
          mov[m[2]](m[3])
        end)
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { enable = false, max_lines = 1, trim_scope = "inner" },
  },
}
