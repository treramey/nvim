local add, gh, later = vim.pack.add, Config.gh, Config.later

later(function()
  add { gh "carderne/pi-nvim" }

  require("pi-nvim").setup {
    set_default_keymaps = false,
  }

  local map = function(mode, lhs, command, description)
    vim.keymap.set(mode, lhs, "<Cmd>" .. command .. "<CR>", { desc = description })
  end

  map("n", "<Leader>aa", "Pi", "send to pi")
  map("x", "<Leader>aa", "Pi", "send selection to pi")
  map("n", "<Leader>ab", "PiSendBuffer", "send buffer to pi")
  map("n", "<Leader>af", "PiSendFile", "send file to pi")
  map("n", "<Leader>ai", "PiPing", "ping pi")
  map("n", "<Leader>as", "PiSessions", "select pi session")
  map("x", "<Leader>as", "PiSendSelection", "send selection to pi")
end)
