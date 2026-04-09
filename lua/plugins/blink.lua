local function is_dap_buffer()
  return require("cmp_dap").is_dap_buffer()
end
return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "rcarriga/cmp-dap",
      "xzbdmw/colorful-menu.nvim",
      "echasnovski/mini.icons",
      { "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = true } },
    },
    version = "v1.*",
    event = "VeryLazy",
    opts = {
      keymap = {
        preset = "none",
        ["<C-k>"] = { "select_prev", "show_signature", "hide_signature", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-Space>"] = { "show", "fallback" },
        ["<C-c>"] = { "cancel", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        -- ["<C-y>"] = {
        --   "snippet_forward",
        --   function()
        --     return require("sidekick").nes_jump_or_apply()
        --   end,
        --   function()
        --     return vim.lsp.inline_completion.get()
        --   end,
        --   "fallback",
        -- },
        ["<Tab>"] = {
          function(cmp)
            -- 1. Handle snippet jumping first
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            end
            -- 2. Try sidekick NES (Next Edit Suggestions)
            local sidekick_ok, sidekick = pcall(require, "sidekick")
            if sidekick_ok and sidekick.nes_jump_or_apply() then
              return true -- consumed by sidekick
            end
            -- 3. Try native inline completion
            if vim.lsp.inline_completion and vim.lsp.inline_completion.get() then
              return true -- consumed by inline completion
            end
            -- 4. Fall back to blink completion
            return cmp.select_next()
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_backward()
            else
              return cmp.select_prev()
            end
          end,
          "fallback",
        },
      },
      enabled = function()
        local ft = vim.bo.filetype
        if ft:match("^snacks_picker") then
          return false
        end
        return vim.bo.buftype ~= "prompt" or is_dap_buffer()
      end,
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },

      completion = {
        trigger = {
          show_on_trigger_character = true,
        },
        menu = {
          border = "rounded",
          max_height = 10,
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
          auto_show = true,
        },
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
          },
        },
        ghost_text = {
          enabled = true,
        },
        list = {
          selection = {
            preselect = true,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
      sources = {
        default = function()
          if is_dap_buffer() then
            return { "lsp", "path", "snippets", "buffer", "easy-dotnet", "dadbod", "dap" }
          end
          return { "lsp", "path", "snippets", "buffer", "easy-dotnet", "dadbod" }
        end,
        providers = {
          lsp = {
            score_offset = 1000, -- Extreme priority to override fuzzy matching
            max_items = 10,
          },
          path = {
            score_offset = 3, -- File paths moderate priority
          },
          snippets = {
            score_offset = -3,
            max_items = 3,
            min_keyword_length = 3,
          },
          buffer = {
            score_offset = -150, -- Lowest priority
            min_keyword_length = 3, -- Only show after 3 chars
          },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink", score_offset = 1000 },
          dap = { name = "dap", module = "blink.compat.source", score_offset = 1000 },
          ["easy-dotnet"] = {
            name = "easy-dotnet",
            enabled = true,
            module = "easy-dotnet.completion.blink",
            score_offset = 1000,
            async = true,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust" },
      snippets = {
        preset = "luasnip",
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_trigger_character = false,
          show_on_insert_on_trigger_character = false,
        },
        window = {
          border = "rounded",
          show_documentation = true,
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
