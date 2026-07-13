local M = {}

local gh = Config.gh

M.default_slug = "rose-pine-main"
M.state_file = vim.fn.stdpath "state" .. "/theme-switcher/theme"
M.trigger_file = vim.fn.expand "~/.cache/nvim-theme-trigger"
M.omarchy_theme_file = vim.fn.expand "~/.config/omarchy/current/theme.name"

-- The catalog below is keyed by nvim-native slugs. Omarchy theme names (and
-- legacy state-file slugs) are translated here as they enter — Omarchy's
-- "rose-pine" is the light Dawn variant.
M.omarchy_aliases = {
  ["rose-pine"] = "rose-pine-dawn",
  ["rose-pine-dark"] = "rose-pine-main",
}

local function normalize(slug)
  if slug == nil then
    return nil
  end
  return M.omarchy_aliases[slug] or slug
end

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
  ["bulwer-omarchy"] = {
    src = gh "bjarneo/aether.nvim",
    name = "aether",
    version = "v3",
    colorscheme = "aether",
    background = "light",
    setup = function()
      require("aether").setup {
        colors = {
          bg = "#f6f1e9",
          dark_bg = "#b9b5af",
          darker_bg = "#7b7975",
          lighter_bg = "#f7f2eb",
          fg = "#241803",
          dark_fg = "#1b1202",
          light_fg = "#453b29",
          bright_fg = "#5b5242",
          muted = "#86837c",
          red = "#936100",
          yellow = "#8c509a",
          orange = "#a37926",
          green = "#007881",
          cyan = "#6e217f",
          blue = "#763900",
          purple = "#00606c",
          brown = "#624917",
          bright_red = "#bc8400",
          bright_yellow = "#b66dcc",
          bright_green = "#2e9ea9",
          bright_cyan = "#973cb1",
          bright_blue = "#9f5914",
          bright_purple = "#2a8494",
          accent = "#763900",
          cursor = "#241803",
          foreground = "#241803",
          background = "#f6f1e9",
          selection = "#f7f2eb",
          selection_foreground = "#241803",
          selection_background = "#f7f2eb",
        },
      }
    end,
  },
  ["rose-pine-main"] = {
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
    version = "v3",
    colorscheme = "aether",
    background = "dark",
    setup = function()
      require("aether").setup {
        transparent = true,
        colors = {
          bg = "#1c1213",
          dark_bg = "#c24f57",
          darker_bg = "#1c1213",
          lighter_bg = "#806c61",
          fg = "#a63650",
          dark_fg = "#6b6566",
          light_fg = "#6b6566",
          bright_fg = "#a87569",
          muted = "#684c59",
          red = "#6d4745",
          yellow = "#806c61",
          orange = "#c24f57",
          green = "#f28171",
          cyan = "#684c59",
          blue = "#a63650",
          purple = "#6b6566",
          brown = "#e3a68c",
          bright_red = "#6d4745",
          bright_yellow = "#806c61",
          bright_green = "#f28171",
          bright_cyan = "#684c59",
          bright_blue = "#a63650",
          bright_purple = "#6b6566",
          accent = "#c24f57",
          cursor = "#a63650",
          foreground = "#a63650",
          background = "#1c1213",
          selection = "#806c61",
          selection_foreground = "#a63650",
          selection_background = "#806c61",
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
    version = "v3",
    colorscheme = "aether",
    background = "dark",
    setup = function()
      require("aether").setup {
        transparent = false,
        colors = {
          bg = "#2c2e27",
          dark_bg = "#2c2e27",
          darker_bg = "#2c2e27",
          lighter_bg = "#a2a49a",
          fg = "#fdfefd",
          dark_fg = "#dde5ca",
          light_fg = "#dde5ca",
          bright_fg = "#fdfefd",
          muted = "#a2a49a",
          red = "#d9bc87",
          yellow = "#dfdfb9",
          orange = "#eedec3",
          green = "#d2dfc1",
          cyan = "#c1cead",
          blue = "#c6d0b6",
          purple = "#cfc9af",
          brown = "#eceae0",
          bright_red = "#eedec3",
          bright_yellow = "#fdfefd",
          bright_green = "#fdfefd",
          bright_cyan = "#fdfefd",
          bright_blue = "#fdfefd",
          bright_purple = "#eceae0",
          accent = "#eedec3",
          cursor = "#fdfefd",
          foreground = "#fdfefd",
          background = "#2c2e27",
          selection = "#a2a49a",
          selection_foreground = "#fdfefd",
          selection_background = "#a2a49a",
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
    version = "v3",
    colorscheme = "aether",
    background = "light",
    setup = function()
      require("aether").setup {
        transparent = false,
        colors = {
          bg = "#d0d0c8",
          dark_bg = "#c4c4bc",
          darker_bg = "#bcbcb4",
          lighter_bg = "#dcdcd4",
          fg = "#242424",
          dark_fg = "#3e3d31",
          light_fg = "#59574d",
          bright_fg = "#242424",
          muted = "#59574d",
          red = "#a32a26",
          yellow = "#794e17",
          orange = "#953b19",
          green = "#3d6035",
          cyan = "#814363",
          blue = "#754e3e",
          purple = "#624d85",
          brown = "#754e3e",
          bright_red = "#a32a26",
          bright_yellow = "#794e17",
          bright_green = "#3d6035",
          bright_cyan = "#814363",
          bright_blue = "#754e3e",
          bright_purple = "#624d85",
          accent = "#953b19",
          cursor = "#242424",
          foreground = "#242424",
          background = "#d0d0c8",
          selection = "#c3c1cf",
          selection_foreground = "#242424",
          selection_background = "#c3c1cf",
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
  ["rose-pine-dawn"] = {
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
  for _, path in ipairs { M.trigger_file, M.omarchy_theme_file, M.state_file } do
    local slug = normalize(read_first_line(path))
    if M.resolve_theme(slug) then
      return slug
    end
  end
  return M.default_slug
end

function M.apply_slug(slug, opts)
  opts = opts or {}
  slug = normalize(slug)
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
    if not timer then
      return
    end
    timer:stop()
    timer:start(75, 0, function()
      vim.schedule(function()
        local slug = normalize(read_first_line(path))
        if slug and slug ~= vim.g.colors_name_slug then
          M.apply_slug(slug, { persist = true, notify = false })
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
