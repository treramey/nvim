return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      {
        "Cliffback/netcoredbg-macOS-arm64.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
      },
      {
        "igorlfs/nvim-dap-view",
        opts = {
          auto_toggle = true,
          follow_tab = true,
          winbar = {
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "console", "repl" },
            default_section = "scopes",
            controls = {
              enabled = true,
              buttons = {
                "play",
                "step_into",
                "step_over",
                "step_out",
                "step_back",
                "terminate",
              },
            },
          },
        },
      },
      -- {
      --   "Weissle/persistent-breakpoints.nvim",
      --   event = { "BufReadPre", "BufNewFile" },
      --   config = function()
      --     require("persistent-breakpoints").setup({
      --       load_breakpoints_event = { "BufReadPost" },
      --     })
      --   end,
      -- },
    },
    config = function()
      local dap, dapui = require("dap"), require("dap-view")
      dap.set_log_level("TRACE")

      -- Keymaps for controlling the debugger
      vim.keymap.set("n", "q", function()
        dap.terminate()
        dap.clear_breakpoints()
        dapui.close()
      end, { desc = "Terminate and clear breakpoints" })

      -- stylua: ignore start
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◉", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "󰳟", texthl = "DiagnosticOk", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "✕", texthl = "DiagnosticError", linehl = "", numhl = "" })

      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/continue debugging" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      -- vim.keymap.set("n", "<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
      -- vim.keymap.set("n", "<leader>dB", function() require("persistent-breakpoints.api").set_conditional_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step over (alt)" })
      vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle DAP REPL" })
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
