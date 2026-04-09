return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufRead",
  opts = {
    disable_diagnostics = true,
  },
  keys = {
    {
      "<leader>gd",
      function()
        require("treramey.merge_diff").open()
      end,
      desc = "3-way merge diff",
    },
    { "<leader>gx", "<cmd>GitConflictListQf<cr>", desc = "conflicts to quickfix" },
  },
}
