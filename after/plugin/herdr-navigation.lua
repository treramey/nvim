-- Seamless <C-h/j/k/l> navigation between Neovim splits and Herdr panes.
-- Move inside Neovim first, then hand focus to Herdr at a split edge.

local function navigate(wincmd, direction)
  local previous_window = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)

  if vim.api.nvim_get_current_win() ~= previous_window then
    return
  end

  if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == "" then
      herdr = "herdr"
    end
    vim.fn.system { herdr, "pane", "focus", "--direction", direction, "--current" }
    return
  end

  local smart_splits_ok, smart_splits = pcall(require, "smart-splits")
  if smart_splits_ok then
    smart_splits["move_cursor_" .. direction]()
  end
end

local function map(lhs, wincmd, direction)
  vim.keymap.set("n", lhs, function()
    navigate(wincmd, direction)
  end, { silent = true, noremap = true, desc = "navigate " .. direction .. " (Neovim/Herdr)" })
end

map("<C-h>", "h", "left")
map("<C-j>", "j", "down")
map("<C-k>", "k", "up")
map("<C-l>", "l", "right")
