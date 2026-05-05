return {
  {
    "rashedInt32/lazydiff.nvim",
    cmd = {
      "Lazydiff",
      "LazydiffOff",
      "LazydiffRefresh",
      "LazydiffNext",
      "LazydiffPrev",
      "LazydiffFirst",
    },
    keys = {
      { "<leader>dd", "<cmd>Lazydiff<cr>", desc = "Toggle lazydiff" },
      { "]h", "<cmd>LazydiffNext<cr>", desc = "Next lazydiff hunk" },
      { "[h", "<cmd>LazydiffPrev<cr>", desc = "Prev lazydiff hunk" },
    },
    config = function()
      require("lazydiff").setup()
    end,
  },
}
