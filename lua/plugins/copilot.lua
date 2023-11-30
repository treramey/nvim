return {
  {
    "zbirenbaum/copilot.lua",
    event = { "BufEnter" },
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-_>",
            dismiss = "<M-/>",
          },
        },
      })
    end,
  },
}
