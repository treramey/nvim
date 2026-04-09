local filtered_message = {
  "No information available",
  "ColdFusion completion source registered with nvim-cmp",
}

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      scratch = {
        win = {
          position = "current",
        },
      },
      bufdelete = { enabled = true },
      git = { enabled = true },
      image = {
        doc = {
          inline = false,
          max_height = 12,
          max_width = 24,
        },
      },
      indent = {
        indent = {
          enabled = false,
        },
        animate = {
          enabled = false,
        },
        scope = {
          treesitter = {
            enabled = true,
          },
        },
      },
      rename = { enabled = true },
      input = {
        enabled = true,
        backdrop = true,
      },
      lazygit = { enabled = false },
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "fancy",
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
      statuscolumn = { enabled = true },
      terminal = {
        win = {
          size = { width = 0.8, height = 0.8 },
          border = "solid",
        },
      },
      toggle = { enabled = true },
      zen = {
        show = {
          statusline = true,
          tabline = true,
        },
      },
      words = { enabled = true },
      styles = {
        input = {
          relative = "cursor",
          title = "",
        },
        snacks_image = {
          relative = "editor",
          border = "none",
          focusable = false,
          backdrop = false,
          row = 1,
          col = -1,
        },
        blame_line = {
          title = "git blame",
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local Snacks = require("snacks")
          local notify = Snacks.notifier.notify
          ---@diagnostic disable-next-line: duplicate-set-field
          Snacks.notifier.notify = function(message, level, opts)
            for _, msg in ipairs(filtered_message) do
              if message == msg then
                return nil
              end
            end
            return notify(message, level, opts)
          end
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            require("snacks").rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
    -- stylua: ignore start
		keys = {
			{ "<leader>.",  function()
				local name = vim.api.nvim_buf_get_name(0)
				if name:find(vim.fn.stdpath("data") .. "/scratch", 1, true) then
					Snacks.bufdelete()
				else
					Snacks.scratch()
				end
			end, desc = "Toggle Scratch Buffer" },
			{ "<leader>B",  function() Snacks.scratch.select() end, desc = "Select Scratch [B]uffer" },
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "[B]uffer [D]elete" },
			{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame Line" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      { "<leader>gh", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gl", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
			{ "<leader>dn", function() Snacks.notifier.hide() end, desc = "[D]ismiss All [N]otifications" },
			{ "<leader>nh", function() Snacks.notifier.show_history() end, desc = "[N]otification [H]istory" },
			{ "<leader>cl", function() Snacks.toggle.option("cursorline", { name = "Cursor Line" }):toggle() end, desc = "Toggle [C]ursor [L]ine" },
			{ "<leader>td", function() Snacks.toggle.diagnostics():toggle() end, desc = "[T]oggle [D]iagnostics" },
			{ "<leader>zm", function() Snacks.toggle.zen():toggle() end, desc = "Toggle [Z]en [M]ode" },
      { "<leader>_",  function() Snacks.terminal() end, desc = "terminal" },
      { "<leader>ln", function() Snacks.toggle.option("relativenumber", { name = "Relative Number" }):toggle() end, desc = "Toggle Relative [L]ine [N]umbers" },
      { "<leader>tw", function() Snacks.toggle.option("wrap"):toggle() end, desc = "[T]oggle line [W]rap" },
      -- stylua: ignore end
			{
				"<leader>Tt",
				function()
					local tsc = require("treesitter-context")
					Snacks.toggle({
						name = "Treesitter Context",
						get = function() return tsc.enabled() end,
						set = function(state)
							if state then
								tsc.enable()
							else
								tsc.disable()
							end
						end,
					}):toggle()
				end,
				desc = "[T]oggle [T]reesitter Context",
			},
			{
				"<leader>hl",
				function()
					local hc = require("nvim-highlight-colors")
					Snacks.toggle({
						name = "Highlight Colors",
						get = function()
							return hc.is_active()
						end,
						set = function(state)
							if state then
								hc.turnOn()
							else
								hc.turnOff()
							end
						end,
					}):toggle()
				end,
				desc = "Toggle [H]igh[L]ight Colors",
			},
      {
      "<leader>ih",
      function()
        Snacks.toggle({
          name = "Inlay Hints",
          get = function()
            return vim.lsp.inlay_hint.is_enabled()
          end,
          set = function(state)
            if state then
              vim.lsp.inlay_hint.enable(true)
            else
              vim.lsp.inlay_hint.enable(false)
            end
          end,
        }):toggle()
      end,
      desc = "Toggle [I]nlay [H]ints",
      },
		},
  },
}
