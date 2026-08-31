local now = Config.now

now(function()
  local theme_switcher = require "treramey.theme_switcher"

  theme_switcher.setup()
end)
