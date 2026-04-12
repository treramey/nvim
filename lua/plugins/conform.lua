return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    notify_on_error = false,
    format_after_save = function(buffer_number)
      local filetype = vim.bo[buffer_number].filetype
      if
        vim.g.disable_autoformat
        or vim.b[buffer_number].disable_autoformat
        or vim.tbl_contains(vim.g.disable_autoformat_filetypes or {}, filetype)
      then
        return
      end
      return {
        async = true,
        timeout_ms = 500,
        lsp_format = "fallback",
      }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      astro = { "oxfmt", "biome", "prettierd", stop_after_first = true },
      javascript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
      typescript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
      typescriptreact = { "oxfmt", "biome", "prettierd", stop_after_first = true },
      svelte = { "oxfmt", "prettierd", stop_after_first = true },
      xml = { "xmlformatter" },
      sql = { "sleek" },
      cs = { "csharpier" },
    },
    formatters = {
      xmlformatter = {
        prepend_args = { "--indent", "4", "--selfclose" },
      },
      oxfmt = {
        condition = function(_, ctx)
          return vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, {
            path = ctx.filename,
            upward = true,
            stop = vim.uv.os_homedir(),
          })[1] ~= nil
        end,
      },
      biome = {
        condition = function(_, ctx)
          return vim.fs.find({ "biome.json", "biome.jsonc" }, {
            path = ctx.filename,
            upward = true,
            stop = vim.uv.os_homedir(),
          })[1] ~= nil
        end,
      },
      prettierd = {
        condition = function(_, ctx)
          return vim.fs.find({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
          }, {
            path = ctx.filename,
            upward = true,
            stop = vim.uv.os_homedir(),
          })[1] ~= nil
        end,
      },
      sleek = {
        command = "sleek",
        args = "--indent-spaces=2 --lines-between-queries=3",
      },
      csharpier = {
        command = "csharpier",
        args = { "format", "--write-stdout", "--stdin-path", "$FILENAME" },
      },
    },
  },
}
