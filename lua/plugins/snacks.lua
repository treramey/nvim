return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      rename = { enabled = true },
      input = {
        enabled = true,
        backdrop = true,
      },
      picker = {
        ui_select = true,
        layout = {
          preset = "minimal",
        },
        layouts = {
          minimal = {
            preview = false,
            layout = {
              backdrop = false,
              width = 0.45,
              height = 0.5,
              border = "single",
              title = "{title}",
              title_pos = "left",
              box = "horizontal",
              {
                box = "vertical",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
              { win = "preview", title = "{preview}", title_pos = "left", border = "left" },
            },
          },
        },
        previewers = {
          diff = {
            builtin = false,
            cmd = { "delta" },
          },
        },
        sources = {
          grep = {
            layout = {
              preview = true,
            },
          },
          icons = {
            layout = {
              preset = "minimal",
            },
          },
          select = {
            layout = {
              preset = "minimal",
            },
          },
        },
      },
      terminal = {
        win = {
          size = { width = 0.8, height = 0.8 },
          border = "solid",
        },
      },
      styles = {
        input = {
          relative = "cursor",
          title = "",
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            require("snacks").rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      { "<leader>gh", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gl", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>_",  function() Snacks.terminal() end, desc = "terminal" },
    },
  },
}
