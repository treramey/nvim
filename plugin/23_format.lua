-- Formatting without plugins ==================================================
-- Uses buffer-local 'formatprg' set per filetype (see after/ftplugin/).
-- Runs program over stdin, applies output only on exit 0, falls back to LSP.

local H = {}

-- Helpers =====================================================================

H.buf_dir = function()
  return vim.fn.expand "%:p:h"
end

-- Check if package.json has a field, e.g. "prettier".
H.pkg_has = function(field)
  ---@diagnostic disable-next-line: param-type-mismatch
  local pkg = vim.fs.find("package.json", { path = H.buf_dir(), upward = true, type = "file" })[1]
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

H.stdout_to_lines = function(stdout)
  local lines = vim.split(stdout or "", "\n", { plain = true })
  if lines[#lines] == "" then
    table.remove(lines)
  end
  return lines
end

H.autoformat_disabled = function(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return true
  end
  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
    return true
  end
  return vim.tbl_contains(vim.g.disable_autoformat_filetypes or {}, vim.bo[bufnr].filetype)
end

-- Prepare cmd for formatters that need filename for EditorConfig resolution
H.fixup_cmd = function(cmd, bufname)
  if bufname == "" then
    return cmd
  end

  -- shfmt ignores EditorConfig on stdin unless --filename is provided
  if cmd[1]:match "shfmt$" then
    if cmd[#cmd] == "-" then
      table.remove(cmd)
    end
    table.insert(cmd, "--filename")
    table.insert(cmd, bufname)
  end

  return cmd
end

-- Check if any LSP client supports formatting.
H.has_lsp_formatter = function(bufnr)
  bufnr = bufnr or 0
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  for _, client in ipairs(clients) do
    if client:supports_method "textDocument/formatting" then
      return true
    end
  end
  return false
end

-- Public API ==================================================================

-- Detect and set buffer-local 'formatprg' for prettier projects.
Config.set_formatprg = function()
  local file = vim.fn.expand "%:p"
  if file == "" then
    return
  end

  local escaped_file = vim.fn.shellescape(file)
  if H.pkg_has '"prettier"' then
    vim.bo.formatprg = "prettierd --stdin-filepath " .. escaped_file
  end
end

-- Format current buffer via 'formatprg', or fall back to LSP.
Config.format = function()
  local prg = vim.bo.formatprg
  if prg == "" then
    if not H.has_lsp_formatter() then
      return
    end
    return vim.lsp.buf.format { timeout_ms = 1000 }
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cmd = vim.fn.shellsplit(vim.fn.expandcmd(prg))
  cmd = H.fixup_cmd(cmd, bufname)

  local cwd = bufname ~= "" and vim.fs.dirname(bufname) or nil
  local ok, out = pcall(function()
    return vim.system(cmd, { stdin = table.concat(lines, "\n"), text = true, cwd = cwd }):wait()
  end)

  if not ok then
    return vim.notify(string.format("[%s] %s", cmd[1] or "format", out), vim.log.levels.ERROR)
  end
  if out.code ~= 0 then
    return vim.notify(string.format("[%s] %s", cmd[1], out.stderr or "format failed"), vim.log.levels.ERROR)
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, H.stdout_to_lines(out.stdout))
end

-- Format on save ==============================================================

if vim.g.format_on_save == nil then
  vim.g.format_on_save = true
end

Config.new_autocmd("BufWritePre", "*", function(args)
  if H.autoformat_disabled(args.buf) then
    return
  end

  local enabled = vim.b[args.buf].format_on_save
  if enabled == nil then
    enabled = vim.g.format_on_save
  end
  if enabled then
    Config.format()
  end
end, "Format on save")
