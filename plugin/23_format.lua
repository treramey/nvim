-- Formatting via conform.nvim =================================================
-- The Formatter Registry: one row per filetype in `formatters_by_ft`. Project
-- formatters (oxfmt/biome/prettierd) gate on project configuration or local
-- binaries. The first available one wins; Biome also organizes imports.

local add, gh, later = vim.pack.add, Config.gh, Config.later

local H = {}

-- Helpers =====================================================================

H.has_config = function(names, file)
  return vim.fs.find(names, { path = file, upward = true, stop = vim.uv.os_homedir() })[1] ~= nil
end

-- Check if package.json (searched upward from `file`) has a field,
-- e.g. "prettier" — prettier config can live there instead of an rc file.
H.pkg_has = function(field, file)
  local pkg = vim.fs.find("package.json", { path = file, upward = true, stop = vim.uv.os_homedir(), type = "file" })[1]
  if not pkg then
    return false
  end
  for line in io.lines(pkg) do
    if line:find(field, 1, true) then
      return true
    end
  end
  return false
end

H.prettier_config = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
}

H.autoformat_disabled = function(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return true
  end
  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
    return true
  end
  return vim.tbl_contains(vim.g.disable_autoformat_filetypes or {}, vim.bo[bufnr].filetype)
end

H.format_after_save_opts = function(bufnr)
  if H.autoformat_disabled(bufnr) then
    return
  end
  return { async = true, timeout_ms = 500, lsp_format = "fallback" }
end

-- Public API ==================================================================

Config.format = function()
  require("conform").format()
end

vim.api.nvim_create_user_command("ConformDisable", function(args)
  if args.bang then
    -- ConformDisable! disables formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("ConformEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })

-- Setup =======================================================================

later(function()
  add { gh "stevearc/conform.nvim" }

  local conform = require "conform"
  local oxfmt_command = require("conform.util").find_executable({
    "node_modules/.bin/oxfmt",
    "node_modules/.bin/vp",
  }, "oxfmt")
  local web_formatters = function(bufnr)
    if conform.get_formatter_info("oxfmt", bufnr).available then
      return { "oxfmt" }
    end
    if conform.get_formatter_info("biome", bufnr).available then
      return { "biome", "biome-organize-imports" }
    end
    return { "prettierd" }
  end

  require("conform").setup {
    notify_on_error = false,
    default_format_opts = {
      async = true,
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    format_after_save = H.format_after_save_opts,
    formatters_by_ft = {
      go = { "gofmt" },
      lua = { "stylua" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      zsh = { "shfmt" },
      svg = { "xmlformat" },
      xml = { "xmlformat" },
      astro = web_formatters,
      javascript = web_formatters,
      javascriptreact = web_formatters,
      typescript = web_formatters,
      typescriptreact = web_formatters,
      svelte = { "oxfmt", "prettierd", stop_after_first = true },
      json = { "biome", "prettierd", stop_after_first = true },
      jsonc = { "biome", "prettierd", stop_after_first = true },
      markdown = { "prettierd" },
      scss = { "prettierd" },
      yaml = { "prettierd" },
    },
    formatters = {
      xmlformat = { args = { "--indent", "4", "--selfclose", "-" } },
      oxfmt = {
        command = oxfmt_command,
        args = function(self, ctx)
          local args = { "--stdin-filepath", "$FILENAME" }
          if vim.fs.basename(oxfmt_command(self, ctx)) == "vp" then
            table.insert(args, 1, "fmt")
          end
          return args
        end,
        condition = function(self, ctx)
          return oxfmt_command(self, ctx) ~= "oxfmt"
            or H.has_config({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }, ctx.filename)
        end,
      },
      biome = {
        condition = function(_, ctx)
          return H.has_config({ "biome.json", "biome.jsonc" }, ctx.filename)
        end,
      },
      ["biome-organize-imports"] = {
        require_cwd = true,
      },
      prettierd = {
        condition = function(_, ctx)
          local ft = vim.bo[ctx.buf].filetype
          return ft == "json"
            or ft == "jsonc"
            or H.has_config(H.prettier_config, ctx.filename)
            or H.pkg_has('"prettier"', ctx.filename)
        end,
      },
    },
  }

  vim.o.formatexpr = 'v:lua.require"conform".formatexpr()'
end)
