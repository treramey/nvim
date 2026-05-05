return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        opts = {
          auto_toggle = "open_term",
          follow_tab = false,
          winbar = {
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
            default_section = "scopes",
          },
          windows = {
            size = 0.35,
            position = "below",
            terminal = {
              size = 0.3,
              position = "below",
              hide = {},
            },
          },
        },
      },
      {
        "Weissle/persistent-breakpoints.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
          require("persistent-breakpoints").setup({
            load_breakpoints_event = { "BufReadPost" },
          })
        end,
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dap-view")
      dap.set_log_level("TRACE")

      local function set_debug_highlights()
        local p = require("treramey.highlights").get_palette()
        local normal = { fg = p.text, bg = p.overlay }
        local border = { fg = p.iris, bg = p.overlay }
        local title = { fg = p.gold, bg = p.overlay, bold = true }

        vim.api.nvim_set_hl(0, "DapHoverNormal", normal)
        vim.api.nvim_set_hl(0, "DapHoverBorder", border)
        vim.api.nvim_set_hl(0, "DapHoverTitle", title)
        vim.api.nvim_set_hl(0, "DapVariableNormal", normal)
        vim.api.nvim_set_hl(0, "DapVariableBorder", border)
        vim.api.nvim_set_hl(0, "DapVariableTitle", title)
        vim.api.nvim_set_hl(0, "EasyDotnetDebuggerFloatVariable", { fg = p.text, bg = p.overlay })
        vim.api.nvim_set_hl(0, "EasyDotnetDebuggerVirtualVariable", { fg = p.iris, bg = p.surface, italic = true })
        vim.api.nvim_set_hl(0, "EasyDotnetDebuggerVirtualException", { fg = p.love, bg = p.surface, italic = true })
      end

      set_debug_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("TrerameyDapHighlights", { clear = true }),
        callback = set_debug_highlights,
      })

      local function show_debug_view(view)
        dapui.open()
        vim.schedule(function()
          dapui.show_view(view)
        end)
      end

      local function style_hover()
        vim.schedule(function()
          local ok, state = pcall(require, "dap-view.state")
          if not ok or not state.hover_winnr or not vim.api.nvim_win_is_valid(state.hover_winnr) then
            return
          end

          local win = state.hover_winnr
          local config = vim.api.nvim_win_get_config(win)
          config.border = "rounded"
          config.title = " Debug value "
          config.title_pos = "left"
          config.zindex = 60
          config.width = math.min(config.width or 1, math.floor(vim.o.columns * 0.72))
          config.height = math.min(config.height or 1, math.floor(vim.o.lines * 0.55))
          pcall(vim.api.nvim_win_set_config, win, config)

          vim.wo[win].cursorline = true
          vim.wo[win].wrap = false
          vim.wo[win].winblend = 4
          vim.wo[win].winhighlight = table.concat({
            "Normal:DapHoverNormal",
            "NormalFloat:DapHoverNormal",
            "FloatBorder:DapHoverBorder",
            "FloatTitle:DapHoverTitle",
            "CursorLine:Visual",
          }, ",")
        end)
      end

      local function hover_debug_value()
        dapui.hover(nil, true)
        style_hover()
      end

      local function style_variable_float(float)
        if not float or not float.win or not vim.api.nvim_win_is_valid(float.win) then
          return
        end

        local width = math.min(math.floor(vim.o.columns * 0.68), 118)
        local height = math.min(math.floor(vim.o.lines * 0.58), 28)
        pcall(vim.api.nvim_win_set_config, float.win, {
          relative = "editor",
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          width = width,
          height = height,
          style = "minimal",
          border = "rounded",
          title = " Variable viewer ",
          title_pos = "left",
          zindex = 60,
        })

        vim.wo[float.win].cursorline = true
        vim.wo[float.win].number = false
        vim.wo[float.win].relativenumber = false
        vim.wo[float.win].wrap = false
        vim.wo[float.win].winblend = 0
        vim.wo[float.win].winhighlight = table.concat({
          "Normal:DapVariableNormal",
          "NormalFloat:DapVariableNormal",
          "FloatBorder:DapVariableBorder",
          "FloatTitle:DapVariableTitle",
          "CursorLine:Visual",
        }, ",")

        if float.buf and vim.api.nvim_buf_is_valid(float.buf) then
          vim.bo[float.buf].filetype = "dap-variable-viewer"
        end
      end

      local function setup_easy_dotnet_variable_float()
        local ok, variable_float = pcall(require, "easy-dotnet.netcoredbg.debugger-float")
        if not ok or variable_float._treramey_styled then
          return
        end

        local original_show = variable_float.show
        variable_float.show = function(...)
          local float = original_show(...)
          style_variable_float(float)
          return float
        end
        variable_float._treramey_styled = true
      end

      -- Keymaps for controlling the debugger
      local function terminate_session()
        pcall(dap.terminate)
        dapui.close(true)
      end

      -- Bind `q` to terminate only while a debug session is active, so macro
      -- recording (q<reg>) keeps working when not debugging.
      dap.listeners.after.event_initialized["q-terminate"] = function()
        vim.keymap.set("n", "q", terminate_session, { desc = "Terminate debug session" })
      end
      local function unbind_q() pcall(vim.keymap.del, "n", "q") end
      dap.listeners.before.event_terminated["q-terminate"] = unbind_q
      dap.listeners.before.event_exited["q-terminate"] = unbind_q
      dap.listeners.after.disconnect["q-terminate"] = unbind_q

      -- stylua: ignore start
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◉", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "󰳟", texthl = "DiagnosticOk", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "✕", texthl = "DiagnosticError", linehl = "", numhl = "" })

      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/continue debugging" })
      vim.keymap.set("n", "<leader>dv", dapui.toggle, { desc = "Toggle debug view" })
      vim.keymap.set("n", "<leader>dt", terminate_session, { desc = "Terminate debug session" })
      vim.keymap.set("n", "<leader>ds", function() show_debug_view("scopes") end, { desc = "Show scopes" })
      vim.keymap.set("n", "<leader>dw", function() show_debug_view("watches") end, { desc = "Show watches" })
      vim.keymap.set("n", "<leader>df", function() show_debug_view("threads") end, { desc = "Show frames" })
      vim.keymap.set("n", "<leader>da", function() dapui.add_expr(nil, true) end, { desc = "Add watch under cursor" })
      vim.keymap.set("n", "<leader>dh", hover_debug_value, { desc = "Hover debug value" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Step out" })
      -- vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function() require("persistent-breakpoints.api").set_conditional_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dx", function() require("persistent-breakpoints.api").clear_all_breakpoints() end, { desc = "Clear all breakpoints" })
      vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step over (alt)" })
      vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
      vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Go down stack frame" })
      vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Go up stack frame" })

      -- stylua: ignore end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      require("easy-dotnet.netcoredbg").register_dap_variables_viewer()
      setup_easy_dotnet_variable_float()

      -- Fix winfixbuf conflict between nvim-dap-view and easy-dotnet
      -- Proactively ensure we're in a suitable window for source display
      dap.listeners.before.event_stopped["winfixbuf-fix"] = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local config = vim.api.nvim_win_get_config(win)
          if not vim.wo[win].winfixbuf and config.relative == "" then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
      end
    end,
  },
}
