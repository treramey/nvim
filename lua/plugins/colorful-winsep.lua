return {
  {
    "nvim-zh/colorful-winsep.nvim",
    event = { "BufReadPre" },
    opts = function(_, opts)
      local palette = require("rose-pine.palette")
      opts = {
        hi = {
          fg = palette.gold,
        },
        smooth = false,
      }
      return opts
    end,
  },
}
