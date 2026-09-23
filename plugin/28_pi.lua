local add, gh, later = vim.pack.add, Config.gh, Config.later

--- Remove dead Windows pi-nvim session markers before socket discovery.
local function clean_stale_pi_nvim_sessions()
  if vim.fn.has "win32" ~= 1 then
    return
  end

  local temp_dir = vim.env.TEMP or vim.env.TMP
  if not temp_dir then
    return
  end

  local sessions_dir = temp_dir:gsub("\\", "/") .. "/pi-nvim-sockets"
  local info_files = vim.fn.glob(sessions_dir .. "/*.info", false, true)

  for _, info_path in ipairs(info_files) do
    local read_ok, lines = pcall(vim.fn.readfile, info_path)
    local decode_ok, session = pcall(vim.json.decode, read_ok and lines[1] or "")

    if decode_ok and type(session.pid) == "number" then
      local _, process_error = vim.uv.kill(session.pid, 0)
      if process_error and process_error:match "^ESRCH" then
        pcall(vim.uv.fs_unlink, info_path)
        pcall(vim.uv.fs_unlink, info_path:sub(1, -6))
      end
    end
  end
end

later(function()
  add { gh "carderne/pi-nvim" }

  local pi_nvim = require "pi-nvim"
  local get_socket_path = pi_nvim.get_socket_path
  pi_nvim.get_socket_path = function()
    clean_stale_pi_nvim_sessions()
    return get_socket_path()
  end

  pi_nvim.setup {
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
