local M = {}

local gh = Config.gh

M.default_slug = "rose-pine"
M.state_file = vim.fn.stdpath "state" .. "/theme-switcher/theme"
M.trigger_file = vim.fn.expand "~/.cache/nvim-theme-trigger"
M.omarchy_theme_file = vim.fn.expand "~/.config/omarchy/current/theme.name"

M.themes = {
  ["catppuccin-latte"] = {
    src = gh "catppuccin/nvim",
    name = "catppuccin",
    colorscheme = "catppuccin-latte",
    background = "light",
  },
  ["catppuccin"] = {
    src = gh "catppuccin/nvim",
    name = "catppuccin",
    colorscheme = "catppuccin",
    background = "dark",
  },
  ["everforest"] = {
    src = gh "neanias/everforest-nvim",
    colorscheme = "everforest",
    background = "dark",
  },
  ["flexoki-light"] = {
    src = gh "kepano/flexoki-neovim",
    colorscheme = "flexoki-light",
    background = "light",
  },
  ["gruvbox"] = {
    src = gh "ellisonleao/gruvbox.nvim",
    colorscheme = "gruvbox",
    background = "dark",
  },
  ["kanagawa"] = {
    src = gh "rebelot/kanagawa.nvim",
    colorscheme = "kanagawa",
    background = "dark",
  },
  ["kanagawa-lotus"] = {
    src = gh "rebelot/kanagawa.nvim",
    colorscheme = "kanagawa-lotus",
    background = "light",
    setup = function()
      ---@diagnostic disable-next-line: missing-fields
      require("kanagawa").setup {
        colors = {
          theme = {
            lotus = {
              ui = {
                bg = "#f1e9d2",
              },
            },
          },
        },
      }
    end,
  },
  ["kanagawa-dragon"] = {
    src = gh "rebelot/kanagawa.nvim",
    colorscheme = "kanagawa-dragon",
    background = "dark",
    setup = function()
      ---@diagnostic disable-next-line: missing-fields
      require("kanagawa").setup {
        colors = {
          theme = {
            dragon = {
              ui = {
                bg = "#181616",
              },
            },
          },
        },
      }
    end,
  },
  ["lumon"] = {
    src = gh "omacom-io/lumon.nvim",
    colorscheme = "lumon",
    background = "dark",
  },
  ["miasma"] = {
    src = gh "OldJobobo/miasma.nvim",
    colorscheme = "miasma",
    background = "dark",
  },
  ["ethereal"] = {
    src = gh "bjarneo/ethereal.nvim",
    colorscheme = "ethereal",
    background = "dark",
  },
  ["hackerman"] = {
    src = gh "bjarneo/hackerman.nvim",
    colorscheme = "hackerman",
    background = "dark",
  },
  ["retro-82"] = {
    src = gh "OldJobobo/retro-82.nvim",
    colorscheme = "retro-82",
    background = "dark",
  },
  ["vantablack"] = {
    src = gh "bjarneo/vantablack.nvim",
    colorscheme = "vantablack",
    background = "dark",
  },
  ["white"] = {
    src = gh "bjarneo/white.nvim",
    colorscheme = "white",
    background = "light",
  },
  ["boring"] = {
    src = gh "folke/tokyonight.nvim",
    colorscheme = "tokyonight-night",
    background = "dark",
  },
  ["rose-pine-dark"] = {
    src = gh "rose-pine/neovim",
    name = "rose-pine",
    colorscheme = "rose-pine",
    background = "dark",
    setup = function()
      ---@diagnostic disable-next-line: missing-fields, param-type-mismatch
      require("rose-pine").setup {
        variant = "main",
        dark_variant = "main",
        highlight_groups = {
          MatchParen = { fg = "love", bg = "love", blend = 25 },
          MiniStarterHeader = { fg = "love" },
        },
      }
    end,
  },
  ["caroline-skyline"] = {
    src = gh "bjarneo/aether.nvim",
    name = "aether",
    version = "v2",
    colorscheme = "aether",
    background = "dark",
    setup = function()
      require("aether").setup {
        transparent = true,
        colors = {
          base00 = "#1c1213",
          base01 = "#c24f57",
          base02 = "#806c61",
          base03 = "#684c59",
          base04 = "#6b6566",
          base05 = "#a63650",
          base06 = "#6b6566",
          base07 = "#a87569",
          base08 = "#6d4745",
          base09 = "#c24f57",
          base0A = "#806c61",
          base0B = "#f28171",
          base0C = "#684c59",
          base0D = "#a63650",
          base0E = "#6b6566",
          base0F = "#e3a68c",
        },
      }
      pcall(function()
        require("aether.hotreload").setup()
      end)
    end,
  },
  ["kurayami"] = {
    src = gh "bjarneo/aether.nvim",
    name = "aether",
    version = "v2",
    colorscheme = "aether",
    background = "dark",
    setup = function()
      require("aether").setup {
        transparent = false,
        colors = {
          bg = "#2c2e27",
          bg_dark = "#2c2e27",
          bg_highlight = "#a2a49a",
          fg = "#fdfefd",
          fg_dark = "#dde5ca",
          comment = "#a2a49a",
          red = "#d9bc87",
          orange = "#eedec3",
          yellow = "#dfdfb9",
          green = "#d2dfc1",
          cyan = "#c1cead",
          blue = "#c6d0b6",
          purple = "#cfc9af",
          magenta = "#eceae0",
        },
      }
      pcall(function()
        require("aether.hotreload").setup()
      end)
    end,
  },
  ["thegreek"] = {
    src = gh "bjarneo/aether.nvim",
    name = "aether",
    version = "v2",
    colorscheme = "aether",
    background = "light",
    setup = function()
      require("aether").setup {
        transparent = false,
        colors = {
          bg = "#d0d0c8",
          bg_dark = "#d0d0c8",
          bg_highlight = "#a2a87c",
          fg = "#242424",
          fg_dark = "#363a34",
          comment = "#7b7b5d",
          red = "#db0030",
          orange = "#ff4800",
          yellow = "#616a55",
          green = "#2e3125",
          cyan = "#480607",
          blue = "#363a34",
          purple = "#6a551b",
          magenta = "#7c773f",
        },
        on_highlights = function(hl, c)
          hl.CursorLine = { bg = "#ddded4" }
          hl.CursorLineNr = { fg = c.orange, bold = true }
          hl["@markup.raw.markdown_inline"] = { bg = "NONE" }
          hl["@markup.raw.block.markdown"] = { bg = "NONE" }
          hl["@markup.quote"] = { bg = "NONE" }
        end,
      }
      pcall(function()
        require("aether.hotreload").setup()
      end)
    end,
  },
  ["matte-black"] = {
    src = gh "tahayvr/matteblack.nvim",
    colorscheme = "matteblack",
    background = "dark",
  },
  ["nord"] = {
    src = gh "EdenEast/nightfox.nvim",
    colorscheme = "nordfox",
    background = "dark",
  },
  ["osaka-jade"] = {
    src = gh "ribru17/bamboo.nvim",
    colorscheme = "bamboo",
    background = "dark",
  },
  ["ristretto"] = {
    src = gh "gthelding/monokai-pro.nvim",
    colorscheme = "monokai-pro",
    background = "dark",
    setup = function()
      ---@diagnostic disable-next-line: missing-fields
      require("monokai-pro").setup {
        filter = "ristretto",
        override = function()
          return {
            NonText = { fg = "#948a8b" },
            MiniIconsGrey = { fg = "#948a8b" },
            MiniIconsRed = { fg = "#fd6883" },
            MiniIconsBlue = { fg = "#85dacc" },
            MiniIconsGreen = { fg = "#adda78" },
            MiniIconsYellow = { fg = "#f9cc6c" },
            MiniIconsOrange = { fg = "#f38d70" },
            MiniIconsPurple = { fg = "#a8a9eb" },
            MiniIconsAzure = { fg = "#a8a9eb" },
            MiniIconsCyan = { fg = "#85dacc" },
          }
        end,
      }
    end,
  },
  ["rose-pine"] = {
    src = gh "rose-pine/neovim",
    name = "rose-pine",
    colorscheme = "rose-pine-dawn",
    background = "light",
    setup = function()
      ---@diagnostic disable-next-line: missing-fields, param-type-mismatch
      require("rose-pine").setup {
        variant = "dawn",
        dark_variant = "main",
        highlight_groups = {
          MatchParen = { fg = "love", bg = "love", blend = 25 },
          MiniStarterHeader = { fg = "love" },
        },
      }
    end,
  },
  ["tokyo-night"] = {
    src = gh "folke/tokyonight.nvim",
    colorscheme = "tokyonight-night",
    background = "dark",
  },
}

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
  return M.themes[slug]
end

function M.slugs()
  local slugs = vim.tbl_keys(M.themes)
  table.sort(slugs)
  return slugs
end

function M.pack_specs()
  local seen = {}
  local specs = {}

  for _, theme in pairs(M.themes) do
    if not seen[theme.src] then
      seen[theme.src] = true
      table.insert(specs, {
        src = theme.src,
        name = theme.name,
        version = theme.version,
      })
    end
  end

  return specs
end

function M.current_slug()
  local slug = read_first_line(M.trigger_file) or read_first_line(M.state_file) or M.default_slug
  if M.resolve_theme(slug) then
    return slug
  end
  return M.default_slug
end

function M.apply_slug(slug, opts)
  opts = opts or {}
  local theme = M.resolve_theme(slug)
  if not theme then
    local msg = "Unknown Neovim theme: " .. tostring(slug)
    if opts.notify ~= false then
      vim.notify(msg, vim.log.levels.ERROR)
    end
    return false, msg
  end

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
    if timer then
      timer:stop()
      timer:start(75, 0, function()
        vim.schedule(function()
          local slug = read_first_line(path)
          if slug and slug ~= vim.g.colors_name_slug then
            M.apply_slug(slug, { persist = true, notify = false })
          end
        end)
      end)
    end
  end

  local ok = event:start(path, {}, on_change)
  if ok then
    table.insert(M._watchers, event)
    if timer then
      table.insert(M._watchers, timer)
    end
  else
    event:close()
    if timer then
      timer:close()
    end
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
