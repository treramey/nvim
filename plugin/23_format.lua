-- Formatting via conform.nvim =================================================
-- The Formatter Registry: one row per filetype in `formatters_by_ft`. Project
-- formatters (oxfmt/biome/prettierd) gate on project config and the first
-- available one wins; falls back to LSP when none applies.

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
      sh = { "shfmt" },
      zsh = { "shfmt" },
      svg = { "xmlformat" },
      xml = { "xmlformat" },
      astro = { "oxfmt", "biome", "prettierd", stop_after_first = true },
      javascript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
      javascriptreact = { "oxfmt", "biome", "prettierd", stop_after_first = true },
      typescript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
      typescriptreact = { "oxfmt", "biome", "prettierd", stop_after_first = true },
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
        condition = function(_, ctx)
          return H.has_config({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, ctx.filename)
        end,
      },
      biome = {
        condition = function(_, ctx)
          return H.has_config({ "biome.json", "biome.jsonc" }, ctx.filename)
        end,
      },
      prettierd = {
        condition = function(_, ctx)
          return H.has_config(H.prettier_config, ctx.filename) or H.pkg_has('"prettier"', ctx.filename)
        end,
      },
    },
  }

  vim.o.formatexpr = 'v:lua.require"conform".formatexpr()'
end)
