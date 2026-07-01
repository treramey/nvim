local add, now = vim.pack.add, Config.now

now(function()
  local theme_switcher = require "treramey.theme_switcher"

  add(theme_switcher.pack_specs())
  theme_switcher.setup()
end)
