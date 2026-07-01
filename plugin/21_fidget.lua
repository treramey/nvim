local add, gh, now = vim.pack.add, Config.gh, Config.now
local notify = require "treramey.notify"

now(function()
  add { gh "j-hui/fidget.nvim" }
  notify.setup()
end)
