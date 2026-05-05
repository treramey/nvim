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
    "nvim-mini/mini.nvim",
    version = false,
    lazy = false,
    priority = 1000,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    config = function()
      -- mini.notify (set up first so vim.notify is overridden before other plugins use it)
      local filtered = {
        ["No information available"] = true,
        ["ColdFusion completion source registered with nvim-cmp"] = true,
        ["Run aborted"] = true,
      }
      local notify = require("mini.notify")
      notify.setup({
        lsp_progress = { enable = true, duration_last = 1000 },
        window = { config = { border = "rounded" }, max_width_share = 0.4 },
      })
      local make_notify = notify.make_notify()
      vim.notify = function(msg, level, opts)
        if filtered[msg] then
          return
        end
        return make_notify(msg, level, opts)
      end

      require("mini.icons").setup({
        filetype = {
          dotenv = { glyph = "", hl = "MiniIconsYellow" },
        },
        file = {
          [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
          ["init.lua"] = { glyph = "󰢱", hl = "MiniIconsAzure" },
        },
        lsp = {
          copilot = { glyph = "", hl = "MiniIconsOrange" },
          snippet = { glyph = "" },
        },
      })

      -- mini.comment with commentstring overrides for CFML / C#
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

            if ft == "cs" then
              return "// %s"
            end
            if ext == "cfc" or ext == "cfs" or ext == "bx" or ext == "bxs" then
              return "// %s"
            end
            if ext == "cfm" or ext == "bxm" then
              return "<!--- %s --->"
            end

            local ok, cs = pcall(require("ts_context_commentstring").calculate_commentstring)
            if ok and cs then
              return cs
            end
            return vim.bo.commentstring or "<!-- %s -->"
          end,
          pad_comment_parts = true,
        },
      })

      require("mini.diff").setup({
        view = {
          style = "sign",
          signs = { add = "┃", change = "┃", delete = "_" },
        },
      })

      require("mini.pairs").setup({
        mappings = {
          ["["] = { action = "open", pair = "[]", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
          ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
          ["("] = { action = "open", pair = "()", neigh_pattern = ".[%s%z%)]", register = { cr = false } },
          ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
          ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
          ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
        },
      })

      require("mini.move").setup({
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
      })

      require("mini.splitjoin").setup({ mappings = { toggle = "<leader>cm" } })
      require("mini.trailspace").setup({})
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.git").setup({})
      require("mini.jump").setup({})
      require("mini.operators").setup({})
      require("mini.bracketed").setup({})
      require("mini.surround").setup({})
      require("mini.bufremove").setup({})
      require("mini.cursorword").setup({})

      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
        draw = { animation = function() return 0 end },
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "dashboard", "snacks_dashboard", "lazy", "mason", "notify", "snacks_picker_input" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })

      require("mini.cmdline").setup({ autocomplete = { enable = false } })

      vim.opt.laststatus = 3
      vim.opt.showmode = false
      local function get_macro_status()
        local recording_register = vim.fn.reg_recording()
        if recording_register == "" then
          return ""
        end
        return "recording @" .. recording_register
      end
      require("mini.statusline").setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local macro = get_macro_status()

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
              { hl = "MiniStatuslineModeCommand", strings = { macro } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            })
          end,
        },
      })

      -- stylua: ignore start
      vim.keymap.set("n", "<leader>ct", function() require("mini.trailspace").trim() end, { desc = "trim trailing whitespace" })
      vim.keymap.set("n", "<leader>bd", function() require("mini.bufremove").delete() end, { desc = "[B]uffer [D]elete" })
      vim.keymap.set("n", "<leader>gb", function() require("mini.git").show_at_cursor() end, { desc = "[G]it [B]lame Line" })
      vim.keymap.set("n", "<leader>dn", function() require("mini.notify").clear() end, { desc = "[D]ismiss All [N]otifications" })
      vim.keymap.set("n", "<leader>nh", function() require("mini.notify").show_history() end, { desc = "[N]otification [H]istory" })
      -- stylua: ignore end
    end,
  },
}
