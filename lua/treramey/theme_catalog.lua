local Catalog = {}

Catalog.default_slug = "rose-pine-main"

local aliases = {
  ["rose-pine"] = "rose-pine-dawn",
  ["rose-pine-dark"] = "rose-pine-main",
}

local themes = {
  ["catppuccin-latte"] = {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
    colorscheme = "catppuccin-latte",
    background = "light",
  },
  ["catppuccin"] = {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
    colorscheme = "catppuccin",
    background = "dark",
  },
  ["everforest"] = {
    src = "https://github.com/neanias/everforest-nvim",
    colorscheme = "everforest",
    background = "dark",
  },
  ["flexoki-light"] = {
    src = "https://github.com/kepano/flexoki-neovim",
    colorscheme = "flexoki-light",
    background = "light",
  },
  ["gruvbox"] = {
    src = "https://github.com/ellisonleao/gruvbox.nvim",
    colorscheme = "gruvbox",
    background = "dark",
  },
  ["kanagawa"] = {
    src = "https://github.com/rebelot/kanagawa.nvim",
    colorscheme = "kanagawa",
    background = "dark",
  },
  ["kanagawa-lotus"] = {
    src = "https://github.com/rebelot/kanagawa.nvim",
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
    src = "https://github.com/rebelot/kanagawa.nvim",
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
    src = "https://github.com/omacom-io/lumon.nvim",
    colorscheme = "lumon",
    background = "dark",
  },
  ["miasma"] = {
    src = "https://github.com/OldJobobo/miasma.nvim",
    colorscheme = "miasma",
    background = "dark",
  },
  ["ethereal"] = {
    src = "https://github.com/bjarneo/ethereal.nvim",
    colorscheme = "ethereal",
    background = "dark",
  },
  ["hackerman"] = {
    src = "https://github.com/bjarneo/hackerman.nvim",
    colorscheme = "hackerman",
    background = "dark",
  },
  ["retro-82"] = {
    src = "https://github.com/OldJobobo/retro-82.nvim",
    colorscheme = "retro-82",
    background = "dark",
  },
  ["vantablack"] = {
    src = "https://github.com/bjarneo/vantablack.nvim",
    colorscheme = "vantablack",
    background = "dark",
  },
  ["white"] = {
    src = "https://github.com/bjarneo/white.nvim",
    colorscheme = "white",
    background = "light",
  },
  ["boring"] = {
    src = "https://github.com/folke/tokyonight.nvim",
    colorscheme = "tokyonight-night",
    background = "dark",
  },
  ["bulwer-omarchy"] = {
    src = "https://github.com/bjarneo/aether.nvim",
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
    src = "https://github.com/rose-pine/neovim",
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
    src = "https://github.com/bjarneo/aether.nvim",
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
    src = "https://github.com/bjarneo/aether.nvim",
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
    src = "https://github.com/bjarneo/aether.nvim",
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
    src = "https://github.com/tahayvr/matteblack.nvim",
    colorscheme = "matteblack",
    background = "dark",
  },
  ["nord"] = {
    src = "https://github.com/EdenEast/nightfox.nvim",
    colorscheme = "nordfox",
    background = "dark",
  },
  ["osaka-jade"] = {
    src = "https://github.com/ribru17/bamboo.nvim",
    colorscheme = "bamboo",
    background = "dark",
  },
  ["ristretto"] = {
    src = "https://github.com/gthelding/monokai-pro.nvim",
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
    src = "https://github.com/rose-pine/neovim",
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
  ["solitude"] = {
    src = "https://github.com/ficcdaf/ashen.nvim",
    colorscheme = "ashen",
    background = "dark",
  },
  ["tokyo-night"] = {
    src = "https://github.com/folke/tokyonight.nvim",
    colorscheme = "tokyonight-night",
    background = "dark",
  },
}

function Catalog.resolve(input)
  if type(input) ~= "string" then
    return { ok = false, error = { tag = "unsupported-theme", input = tostring(input) } }
  end

  if input == "" then
    return { ok = false, error = { tag = "invalid-input", reason = "empty" } }
  end

  if input:find "[\r\n]" then
    return { ok = false, error = { tag = "invalid-input", reason = "multiline" } }
  end

  local slug = aliases[input]
  if slug then
    return { ok = true, value = { tag = "alias", input = input, slug = slug } }
  end

  if themes[input] then
    return { ok = true, value = { tag = "canonical", slug = input } }
  end

  return { ok = false, error = { tag = "unsupported-theme", input = input } }
end

function Catalog.theme(slug)
  return themes[slug]
end

function Catalog.slugs()
  local slugs = {}
  for slug in pairs(themes) do
    table.insert(slugs, slug)
  end
  table.sort(slugs)
  return slugs
end

function Catalog.project_pack_specs(definitions)
  local by_src = {}

  for _, theme in pairs(definitions) do
    local spec = { src = theme.src, name = theme.name, version = theme.version }
    local existing = by_src[spec.src]
    if existing and (existing.name ~= spec.name or existing.version ~= spec.version) then
      error("conflicting-plugin-spec: " .. spec.src)
    end
    by_src[spec.src] = existing or spec
  end

  local sources = {}
  for src in pairs(by_src) do
    table.insert(sources, src)
  end
  table.sort(sources)

  local specs = {}
  for _, src in ipairs(sources) do
    table.insert(specs, by_src[src])
  end
  return specs
end

function Catalog.pack_specs()
  return Catalog.project_pack_specs(themes)
end

return Catalog
