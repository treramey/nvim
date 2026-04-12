return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {},
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end,
  },
  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    opts = {},
    config = function()
      -- Setup the correct comment string
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.cfc", "*.cfs", "*.bx", "*.bxs" },
        callback = function()
          vim.opt.commentstring = "// %s"
        end,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.cfm", "*.bxm" },
        callback = function()
          vim.opt.commentstring = "<!--- %s --->"
        end,
      })

      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            local ft = vim.bo.filetype
            local ext = vim.fn.expand("%:e")

            -- C# files
            if ft == "cs" then
              return "// %s"
            end

            -- ColdFusion component/script files
            if ext == "cfc" or ext == "cfs" or ext == "bx" or ext == "bxs" then
              return "// %s"
            end

            -- ColdFusion markup files
            if ext == "cfm" or ext == "bxm" then
              return "<!--- %s --->"
            end

            -- Fall back to ts_context_commentstring or default commentstring
            local ok, cs = pcall(require("ts_context_commentstring").calculate_commentstring)
            if ok and cs then
              return cs
            end
            return vim.bo.commentstring or "<!-- %s -->"
          end,
          pad_comment_parts = true,
        },
      })
    end,
  },
  {
    "nvim-mini/mini.diff",
    version = false,
    event = "VeryLazy",
    main = "mini.diff",

    opts = {
      view = {
        style = "sign",
        signs = { add = "┃", change = "┃", delete = "_" },
      },
    },
  },

  {
    "nvim-mini/mini.icons",
    opts = {
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["init.lua"] = { glyph = "󰢱", hl = "MiniIconsAzure" },
      },
      lsp = {
        copilot = { glyph = "", hl = "MiniIconsOrange" },
        snippet = { glyph = "" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-mini/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {
      mappings = {
        ["["] = { action = "open", pair = "[]", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
        ["("] = { action = "open", pair = "()", neigh_pattern = ".[%s%z%)]", register = { cr = false } },
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
      },
    },
  },
  {
    "nvim-mini/mini.move",
    version = false,
    event = "BufReadPre",
    opts = {
      mappings = {
        left = "<",
        down = "-",
        up = "_",
        right = ">",
        line_left = "<",
        line_down = "-",
        line_up = "_",
        line_right = ">",
      },
    },
  },
  {
    "nvim-mini/mini.splitjoin",
    version = false,
    event = "BufReadPre",
    opts = { mappings = { toggle = "<leader>cm" } },
  },
  {
    "nvim-mini/mini.trailspace",
    version = false,
    event = "BufReadPre",
    opts = {},
    keys = {
      --stylua: ignore start
      { "<leader>ct", function() require("mini.trailspace").trim() end, desc = "trim trailing whitespace" },
      --stylua: ignore end
    },
  },
  { "nvim-mini/mini.ai", version = false, event = "VeryLazy", opts = { n_lines = 500 } },
  { "nvim-mini/mini-git", version = false, main = "mini.git", event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.jump", version = false, event = "BufReadPre", opts = {} },
  { "nvim-mini/mini.operators", version = false, event = "BufReadPre", opts = {} },
  { "nvim-mini/mini.bracketed", version = false, event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.surround", event = "BufReadPre", version = false, opts = {} },
}
