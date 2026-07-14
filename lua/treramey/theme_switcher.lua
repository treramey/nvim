local M = {}

local Catalog = require "treramey.theme_catalog"

M.default_slug = Catalog.default_slug
M.state_file = vim.fn.stdpath "state" .. "/theme-switcher/theme"
M.trigger_file = vim.fn.expand "~/.cache/nvim-theme-trigger"
M.omarchy_theme_file = vim.fn.expand "~/.config/omarchy/current/theme.name"

local function read_first_line(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local line = f:read "*l"
  f:close()
  return line
end

local function write_file(path, text)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local f = assert(io.open(path, "w"))
  f:write(text)
  f:write "\n"
  f:close()
end

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

function M.apply_highlights()
  local prompt = hl "DiagnosticFloatingInfo"
  local title = hl "FloatTitle"
  local normal_float = hl "NormalFloat"
  local normal = hl "Normal"

  vim.api.nvim_set_hl(0, "MiniInputPrompt", {
    fg = prompt.fg or title.fg or normal.fg,
    bg = normal_float.bg or normal.bg,
    bold = prompt.bold or title.bold,
  })

  -- Match the native completion popup (used by command-line completion) to the
  -- quiet mini.pick-style floats: dark body, low-contrast border/scrollbar, and
  -- a neutral cursor-line selection instead of the theme's colored popup menu.
  local cursor_line = hl "CursorLine"
  local float_border = hl "FloatBorder"
  local menu_bg = normal_float.bg or normal.bg
  local menu_fg = normal_float.fg or normal.fg
  local selection_bg = cursor_line.bg or normal_float.bg or normal.bg

  vim.api.nvim_set_hl(0, "Pmenu", { fg = menu_fg, bg = menu_bg })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = normal.fg or menu_fg, bg = selection_bg })
  vim.api.nvim_set_hl(0, "PmenuKind", { fg = menu_fg, bg = menu_bg })
  vim.api.nvim_set_hl(0, "PmenuExtra", { fg = menu_fg, bg = menu_bg })
  vim.api.nvim_set_hl(0, "PmenuKindSel", { fg = normal.fg or menu_fg, bg = selection_bg })
  vim.api.nvim_set_hl(0, "PmenuExtraSel", { fg = normal.fg or menu_fg, bg = selection_bg })
  vim.api.nvim_set_hl(0, "PmenuBorder", { fg = menu_bg, bg = menu_bg })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = menu_bg })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = selection_bg })
  vim.api.nvim_set_hl(0, "WildMenu", { fg = normal.fg or menu_fg, bg = selection_bg })

  -- Keep float borders quiet when a theme gives them a bright background.
  vim.api.nvim_set_hl(0, "FloatBorder", {
    fg = float_border.fg or menu_fg,
    bg = menu_bg,
  })

  -- Keep the number/sign gutter transparent. Some colorschemes give LineNr
  -- and diagnostic sign groups their own background, which shows up as a
  -- block beside transparent terminal backgrounds/wallpapers.
  for _, group in ipairs {
    "LineNr",
    "LineNrAbove",
    "LineNrBelow",
    "CursorLineNr",
    "CursorLineSign",
    "CursorLineFold",
    "SignColumn",
    "FoldColumn",
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
    "DiagnosticSignOk",
    "MiniDiffSignAdd",
    "MiniDiffSignChange",
    "MiniDiffSignDelete",
  } do
    local ok, current = pcall(hl, group)
    if ok then
      current.bg = nil
      current.ctermbg = nil
      vim.api.nvim_set_hl(0, group, current)
    end
  end

  -- Keep passive statusline sections transparent too. This removes the boxed
  -- background behind git/diagnostic/filepath/fileinfo sections while leaving
  -- the mode and cursor-position pills intact.
  for _, group in ipairs {
    "StatusLine",
    "StatusLineNC",
    "MiniStatuslineDevinfo",
    "MiniStatuslineFilename",
    "MiniStatuslineFileinfo",
    "MiniStatuslineInactive",
  } do
    local ok, current = pcall(hl, group)
    if ok then
      current.bg = nil
      current.ctermbg = nil
      vim.api.nvim_set_hl(0, group, current)
    end
  end
end

function M.resolve_theme(slug)
  return Catalog.theme(slug)
end

function M.slugs()
  return Catalog.slugs()
end

function M.pack_specs()
  return Catalog.pack_specs()
end

function M.current_slug()
  for _, path in ipairs { M.trigger_file, M.omarchy_theme_file, M.state_file } do
    local result = Catalog.resolve(read_first_line(path))
    if result.ok then
      return result.value.slug
    end
  end
  return M.default_slug
end

function M.apply_slug(slug, opts)
  opts = opts or {}
  local result = Catalog.resolve(slug)
  if not result.ok then
    local msg = "Unknown Neovim theme: " .. tostring(slug)
    if opts.notify ~= false then
      vim.notify(msg, vim.log.levels.ERROR)
    end
    return false, msg
  end

  slug = result.value.slug
  local theme = Catalog.theme(slug)
  vim.o.background = theme.background or "dark"

  if theme.setup then
    local ok, err = pcall(theme.setup)
    if not ok and opts.notify ~= false then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end

  local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
  if not ok then
    if opts.notify ~= false then
      vim.notify(err, vim.log.levels.ERROR)
    end
    return false, err
  end

  vim.g.colors_name_slug = slug
  M.apply_highlights()

  if opts.persist ~= false then
    write_file(M.state_file, slug)
  end

  if opts.notify ~= false then
    vim.notify("Neovim theme: " .. slug .. " (" .. theme.colorscheme .. ")")
  end

  return true
end

function M.watch_file(path)
  if vim.fn.filereadable(path) ~= 1 then
    return
  end

  local event = vim.uv.new_fs_event()
  if not event then
    return
  end

  local timer = vim.uv.new_timer()
  local on_change = function()
    if not timer then
      return
    end
    timer:stop()
    timer:start(75, 0, function()
      vim.schedule(function()
        local result = Catalog.resolve(read_first_line(path))
        if result.ok and result.value.slug ~= vim.g.colors_name_slug then
          M.apply_slug(result.value.slug, { persist = true, notify = false })
        end
      end)
    end)
  end

  local ok = event:start(path, {}, on_change)
  if not ok then
    event:close()
    if timer then
      timer:close()
    end
    return
  end

  table.insert(M._watchers, event)
  if timer then
    table.insert(M._watchers, timer)
  end
end

function M.watch_theme_changes()
  M._watchers = M._watchers or {}
  M.watch_file(M.trigger_file)
  M.watch_file(M.omarchy_theme_file)
end

function M.setup()
  M.apply_slug(M.current_slug(), { notify = false, persist = false })
  M.watch_theme_changes()

  vim.api.nvim_create_user_command("ThemeSwitch", function(args)
    M.apply_slug(args.args, { persist = true })
  end, {
    nargs = 1,
    complete = function()
      return M.slugs()
    end,
  })
end

return M
