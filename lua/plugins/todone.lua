return {
  "ntocampos/todone.nvim",
  dependencies = {
    { "folke/snacks.nvim", optional = true },
  },
  opts = {
    root_dir = "~/todone/",
    float_position = "topright",
  },
  keys = {
    { "<leader>tt", "<cmd>TodoneToday<cr>", desc = "Open today's notes" },
    { "<leader>tf", "<cmd>TodoneToggleFloat<cr>", desc = "Toggle priority float" },
    { "<leader>tl", "<cmd>TodoneList<cr>", desc = "List all notes" },
    { "<leader>tg", "<cmd>TodoneGrep<cr>", desc = "Search inside all notes" },
    { "<leader>tp", "<cmd>TodonePending<cr>", desc = "List notes with pending tasks" },
  },
}
