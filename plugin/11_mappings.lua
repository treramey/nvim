local copy_line_diagnostics_to_clipboard = function()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(0, { lnum = line })

  if #diagnostics == 0 then
    vim.notify("No diagnostics on the current line.", vim.log.levels.INFO)
    return
  end

  local messages = vim.tbl_map(function(diagnostic)
    return diagnostic.message
  end, diagnostics)

  vim.fn.setreg("+", table.concat(messages, "\n"))
  vim.notify("Diagnostics copied to clipboard.", vim.log.levels.INFO)
end

local toggle_diff_overlay = function()
  local diff = require "mini.diff"
  local buf = vim.api.nvim_get_current_buf()

  if not diff.get_buf_data(buf) then
    diff.enable(buf)
  end

  vim.defer_fn(function()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    local data = diff.get_buf_data(buf)
    if not data then
      vim.notify("MiniDiff is not enabled for this buffer.", vim.log.levels.INFO)
      return
    end

    if #data.hunks == 0 then
      vim.notify("MiniDiff: no git changes in this buffer.", vim.log.levels.INFO)
      return
    end

    diff.toggle_overlay(buf)
    local overlay = diff.get_buf_data(buf).overlay and "on" or "off"
    vim.notify("MiniDiff overlay: " .. overlay, vim.log.levels.INFO)
  end, 250)
end

local open_link = function()
  local line = vim.fn.getline "."
  local col = vim.fn.col "."

  local md_link_pattern = "%[.-%]%((.-)%)"
  local url_pattern = "https?://[%w-_%.%?%.:/%+=&]+"

  local start_pos = 1
  while true do
    local md_start, md_end, url = line:find(md_link_pattern, start_pos)
    if not md_start then
      break
    end

    if col >= md_start and col <= md_end then
      vim.ui.open(url)
      return
    end

    start_pos = md_end + 1
  end

  start_pos = 1
  while true do
    local url_start, url_end = line:find(url_pattern, start_pos)
    if not url_start then
      break
    end

    if col >= url_start and col <= url_end then
      vim.ui.open(line:sub(url_start, url_end))
      return
    end

    start_pos = url_end + 1
  end

  vim.ui.open(vim.fn.expand "<cWORD>")
end

pcall(vim.api.nvim_del_user_command, "RotateWindows")
vim.api.nvim_create_user_command("RotateWindows", function()
  local ignored_filetypes = { "neo-tree", "Outline", "toggleterm", "qf", "notify" }
  local windows_to_rotate = {}

  for _, window_number in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buffer_number = vim.api.nvim_win_get_buf(window_number)
    local filetype = vim.bo[buffer_number].filetype

    if not vim.tbl_contains(ignored_filetypes, filetype) then
      table.insert(windows_to_rotate, { window_number = window_number, buffer_number = buffer_number })
    end
  end

  local num_eligible_windows = vim.tbl_count(windows_to_rotate)
  if num_eligible_windows == 0 then
    return
  elseif num_eligible_windows == 1 then
    vim.api.nvim_err_writeln "There is no other window to rotate with."
    return
  elseif num_eligible_windows == 2 then
    local first_window = windows_to_rotate[1]
    local second_window = windows_to_rotate[2]
    vim.api.nvim_win_set_buf(first_window.window_number, second_window.buffer_number)
    vim.api.nvim_win_set_buf(second_window.window_number, first_window.buffer_number)
  else
    vim.api.nvim_err_writeln("You can only swap 2 open windows. Found " .. num_eligible_windows .. ".")
  end
end, { desc = "Rotate open windows" })

-- =============================================================================
-- Mapping helpers
-- =============================================================================

local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

local nmap = function(lhs, rhs, desc, opts)
  map("n", lhs, rhs, desc, opts)
end
local imap = function(lhs, rhs, desc, opts)
  map("i", lhs, rhs, desc, opts)
end
local vmap = function(lhs, rhs, desc, opts)
  map("v", lhs, rhs, desc, opts)
end
local xmap = function(lhs, rhs, desc, opts)
  map("x", lhs, rhs, desc, opts)
end
local tmap = function(lhs, rhs, desc, opts)
  map("t", lhs, rhs, desc, opts)
end

local nmap_leader = function(suffix, rhs, desc, opts)
  nmap("<Leader>" .. suffix, rhs, desc, opts)
end
local xmap_leader = function(suffix, rhs, desc, opts)
  xmap("<Leader>" .. suffix, rhs, desc, opts)
end

-- =============================================================================
-- Shared mapping callbacks
-- =============================================================================

local function valid_filesystem_path(path)
  if path == "" or path:find("://", 1, true) then
    return nil
  end

  local ok, stat = pcall(vim.uv.fs_stat, path)
  if not ok or not stat then
    return nil
  end

  return path
end

local explore_directory = function()
  MiniFiles.open(vim.fn.getcwd())
end

local explore_at_file = function()
  local path = vim.api.nvim_buf_get_name(0)
  MiniFiles.open(valid_filesystem_path(path) or vim.fn.getcwd())
end

local explore_quickfix = function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen")
end

local explore_locations = function()
  local loclist_winid = vim.fn.getloclist(0, { winid = true }).winid
  if loclist_winid ~= 0 then
    vim.cmd "lclose"
    return
  end

  if vim.tbl_isempty(vim.fn.getloclist(0)) then
    vim.notify("No location list for this window", vim.log.levels.INFO)
    return
  end

  vim.cmd "lopen"
end

local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

local get_visual_selection = function()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local opts = { type = vim.fn.visualmode() }
  local ok, lines = pcall(vim.fn.getregion, start_pos, end_pos, opts)
  if not ok then
    return ""
  end
  return table.concat(lines, "\n")
end

local grep_visual_selection = function()
  local pattern = vim.trim(get_visual_selection())
  if pattern == "" then
    return
  end

  require("mini.pick").builtin.grep { pattern = pattern, method = "plain" }
end

local todo_pattern = [[\v<(TODO|Todo|todo|FIXME|Fixme|fixme|HACK|Hack|hack|NOTE|Note|note)>]]
local jump_todo = function(backward)
  local found = vim.fn.search(todo_pattern, backward and "b" or "")
  if found ~= 0 then
    vim.cmd "normal! zz"
  end
end

-- =============================================================================
-- mini.clue leader group labels
-- =============================================================================

Config.leader_group_clues = {
  { mode = "n", keys = "<Leader>a", desc = "+agent" },
  { mode = "n", keys = "<Leader>b", desc = "+buffer" },
  { mode = "n", keys = "<Leader>c", desc = "+quickfix" },
  { mode = "n", keys = "<Leader>e", desc = "+explore" },
  { mode = "n", keys = "<Leader>g", desc = "+git" },
  { mode = "n", keys = "<Leader>l", desc = "+language" },
  { mode = "n", keys = "<Leader>m", desc = "+map" },
  { mode = "n", keys = "<Leader>n", desc = "+notifications" },
  { mode = "n", keys = "<Leader>o", desc = "+other" },
  { mode = "n", keys = "<Leader>s", desc = "+search" },
  { mode = "n", keys = "<Leader>x", desc = "+session" },

  { mode = "x", keys = "<Leader>s", desc = "+search" },
  { mode = "x", keys = "<Leader>g", desc = "+git" },
  { mode = "x", keys = "<Leader>l", desc = "+language" },
  { mode = "x", keys = "<Leader>p", desc = "+paste" },
}

-- =============================================================================
-- Same keys as lua/treramey/keymaps.lua
-- =============================================================================

-- Normal mode -----------------------------------------------------------------
nmap("<Space>", "<Nop>", "Disable space (leader) in normal mode")
nmap("<C-/>", "<Nop>")

nmap_leader("w", "<Cmd>w<CR>", "Save current buffer", { silent = false })
nmap_leader("q", function()
  if vim.wo.diff then
    vim.cmd "diffoff!"
  end
  vim.cmd "confirm q"
end, "Quit current buffer", { silent = false })

-- Center while navigating
nmap("<C-u>", "<C-u>zz", "Scroll up and center cursor")
nmap("<C-d>", "<C-d>zz", "Scroll down and center cursor")
nmap("{", "{zz", "Jump to previous paragraph and center")
nmap("}", "}zz", "Jump to next paragraph and center")
nmap("N", "Nzz", "Search previous and center")
nmap("n", "nzz", "Search next and center")
nmap("G", "Gzz", "Go to end of file and center")
nmap("gg", "ggzz", "Go to beginning of file and center")
nmap("<C-i>", "<C-i>zz", "Jump forward in jump list and center")
nmap("<C-o>", "<C-o>zz", "Jump backward in jump list and center")
nmap("%", "%zz", "Jump to matching bracket and center")
nmap("*", "*zz", "Search for word under cursor and center")
nmap("#", "#zz", "Search backward for word under cursor and center")

nmap("S", function()
  local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
  local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end, "Quick search/replace word under cursor")

nmap("L", "$", "Jump to end of line")
nmap("H", "^", "Jump to beginning of line")
nmap("U", "<C-r>", "Redo last change")
nmap_leader("os", "<Cmd>noh<CR>", "clear search highlighting")

-- Window / other --------------------------------------------------------------
nmap_leader("=", "<C-w>=", "Equalize split window sizes")
nmap("gx", open_link, "Open link under cursor (supports markdown and parens)", { silent = true })

-- Language --------------------------------------------------------------------
nmap_leader("la", vim.lsp.buf.code_action, "actions")
nmap_leader("ld", function()
  vim.diagnostic.open_float { border = "rounded" }
end, "diagnostic popup")
nmap_leader("lD", copy_line_diagnostics_to_clipboard, "copy line diagnostics")
nmap_leader("lf", function()
  Config.format()
end, "format")
nmap_leader("li", '<Cmd>Pick lsp scope="implementation"<CR>', "implementation")
nmap_leader("lh", function()
  return vim.lsp.buf.hover { border = "rounded" }
end, "hover")
nmap_leader("ll", "<Cmd>lua vim.lsp.codelens.run()<CR>", "lens")
nmap_leader("lr", vim.lsp.buf.rename, "rename")
nmap_leader("lR", '<Cmd>Pick lsp scope="references"<CR>', "references")
nmap_leader("ls", function()
  vim.lsp.buf.definition()
  vim.schedule(function()
    vim.cmd "normal! zz"
  end)
end, "source definition")
nmap_leader("lt", vim.lsp.buf.type_definition, "type definition")
nmap_leader("lc", "<Cmd>lua Config.tsc()<CR>", "typecheck project")

-- Direct LSP ------------------------------------------------------------------
nmap("gd", function()
  vim.lsp.buf.definition()
  vim.schedule(function()
    vim.cmd "normal! zz"
  end)
end, "LSP: Go to definition")
nmap("gr", '<Cmd>Pick lsp scope="references"<CR>', "LSP: Go to references")
nmap("gi", '<Cmd>Pick lsp scope="implementation"<CR>', "LSP: Go to implementations")
nmap("K", function()
  return vim.lsp.buf.hover { border = "rounded" }
end, "LSP: Hover documentation")
imap("<C-k>", function()
  return vim.lsp.buf.signature_help { border = "rounded" }
end, "LSP: Signature help")
nmap("gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
nmap("td", vim.lsp.buf.type_definition, "LSP: Type definition")

-- TODO navigation
nmap("]t", function()
  jump_todo(false)
end, "Jump to next TODO")
nmap("[t", function()
  jump_todo(true)
end, "Jump to previous TODO")

-- Insert mode -----------------------------------------------------------------
imap("jj", "<Esc>", "Exit insert mode (jj)")
imap("JJ", "<Esc>", "Exit insert mode (JJ)")

-- Visual mode -----------------------------------------------------------------
vmap("<Space>", "<Nop>", "Disable space (leader) in visual mode")
vmap("L", "$<Left>", "Move to end of line in visual mode")
vmap("H", "^", "Move to beginning of line in visual mode")
vmap("<A-j>", ":m '>+1<CR>gv=gv", "Move selected block down")
vmap("<A-k>", ":m '<-2<CR>gv=gv", "Move selected block up")
xmap_leader("p", '"_dP', "Paste without overwriting register")
xmap("<", "<gv", "Indent left and reselect visual block")
xmap(">", ">gv", "Indent right and reselect visual block")

-- Toggles ---------------------------------------------------------------------
nmap_leader("oc", function()
  vim.wo.cursorline = not vim.wo.cursorline
end, "toggle cursorline")

nmap_leader("oD", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, "toggle diagnostics")

nmap_leader("on", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, "toggle relative line numbers")

nmap_leader("ow", function()
  vim.wo.wrap = not vim.wo.wrap
end, "toggle line wrap")

nmap_leader("oh", function()
  require("mini.hipatterns").toggle()
end, "toggle highlight colors")

nmap_leader("lI", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, "toggle inlay hints")

-- =============================================================================
-- New vim.pack / mini.nvim keymaps not present in lua/treramey/keymaps.lua
-- =============================================================================

-- Paste -----------------------------------------------------------
nmap("[p", '<Cmd>exe "iput! " . v:register<CR>', "paste above")
nmap("]p", '<Cmd>exe "iput "  . v:register<CR>', "paste below")
nmap("<Esc>", "<Cmd>noh<CR>", "clear search highlight")

-- smart-splits.nvim -----------------------------------------------------------
nmap("<C-h>", "<Cmd>lua require('smart-splits').move_cursor_left()<CR>", "navigate left")
nmap("<C-j>", "<Cmd>lua require('smart-splits').move_cursor_down()<CR>", "navigate down")
nmap("<C-k>", "<Cmd>lua require('smart-splits').move_cursor_up()<CR>", "navigate up")
nmap("<C-l>", "<Cmd>lua require('smart-splits').move_cursor_right()<CR>", "navigate right")
nmap("<C-\\>", "<Cmd>lua require('smart-splits').move_cursor_previous()<CR>", "navigate previous")

-- Nordic keyboard remaps removed. Use the common Vim equivalents instead:
--   marks leader: \
--   previous/next motions: [ and ]
--   previous/next paragraph: { and }
--   first non-blank / end of line: ^ and $

-- Agent -------------------------------------------------------------------------
-- Eager require so :SendPathToAgent is registered at startup, not on first keypress.
local send_path_to_agent = require "treramey.send_path_to_agent"
nmap_leader("ap", send_path_to_agent.send_path_to_agent, "send path to agent")

-- Buffer ----------------------------------------------------------------------
nmap_leader("ba", "<Cmd>b#<CR>", "alternate")
nmap_leader("bd", "<Cmd>lua MiniBufremove.delete()<CR>", "delete")
nmap_leader("bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>", "delete!")
nmap_leader("bs", new_scratch_buffer, "scratch")
nmap_leader("bw", "<Cmd>lua MiniBufremove.wipeout()<CR>", "wipeout")
nmap_leader("bW", "<Cmd>lua MiniBufremove.wipeout(0, true)<CR>", "wipeout!")
nmap_leader("bq", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current then
      MiniBufremove.delete(buf)
    end
  end
end, "delete others")

-- Explore ---------------------------------------------------------------------
nmap_leader("ed", explore_directory, "directory")
nmap_leader("ef", explore_at_file, "file directory")
nmap_leader("nh", function()
  require("treramey.notify").show_history()
end, "notifications")

-- Quickfix / location ---------------------------------------------------------
nmap_leader("cn", "<Cmd>cnext<CR>zz", "quickfix next")
nmap_leader("cp", "<Cmd>cprevious<CR>zz", "quickfix previous")
nmap_leader("co", explore_quickfix, "quickfix list")
nmap_leader("cc", "<Cmd>cclose<CR>", "quickfix close")
nmap_leader("cl", explore_locations, "location list")

-- Search ----------------------------------------------------------------------
nmap_leader("sb", "<Cmd>Pick buffers<CR>", "buffers")
nmap_leader("sf", "<Cmd>Pick files<CR>", "files")
nmap_leader("sg", "<Cmd>Pick grep_live<CR>", "grep")
xmap_leader("sg", grep_visual_selection, "grep selection")
nmap_leader("sw", "<Cmd>Pick grep pattern='<cword>'<CR>", "word")
nmap_leader("st", function()
  require("mini.extra").pickers.hipatterns {
    highlighters = { "todo", "fixme", "hack", "note" },
  }
end, "todos")
nmap_leader("so", '<Cmd>Pick lsp scope="document_symbol"<CR>', "symbols")
nmap_leader("sd", '<Cmd>Pick diagnostic scope="all"<CR>', "diagnostics workspace")
nmap_leader("sD", '<Cmd>Pick diagnostic scope="current"<CR>', "diagnostics buffer")
nmap_leader("sh", "<Cmd>Pick help<CR>", "help tags")

-- Git -------------------------------------------------------------------------
nmap_leader("gd", toggle_diff_overlay, "toggle overlay")
nmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "show at cursor")
xmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "show at selection")
nmap_leader("gc", "<Cmd>Pick git_commits<CR>", "commits all")
nmap_leader("gC", '<Cmd>Pick git_commits path="%"<CR>', "commits buffer")

-- Map -------------------------------------------------------------------------
nmap_leader("mf", "<Cmd>lua MiniMap.toggle_focus()<CR>", "focus toggle")
nmap_leader("mr", "<Cmd>lua MiniMap.refresh()<CR>", "refresh")
nmap_leader("mt", "<Cmd>lua MiniMap.toggle()<CR>", "toggle")

-- Other -----------------------------------------------------------------------
nmap_leader("or", "<Cmd>lua MiniMisc.resize_window()<CR>", "resize to default width")
nmap_leader("ot", "<Cmd>lua MiniTrailspace.trim()<CR>", "trim trailspace")
nmap_leader("oz", "<Cmd>lua MiniMisc.zoom()<CR>", "zoom toggle")
nmap_leader("oR", ":RotateWindows<CR>", "rotate open windows")

-- Sessions --------------------------------------------------------------------
local session_new = 'vim.ui.input({ prompt = "Session name: " }, MiniSessions.write)'
nmap_leader("xd", '<Cmd>lua MiniSessions.select("delete")<CR>', "delete")
nmap_leader("xn", "<Cmd>lua " .. session_new .. "<CR>", "new")
nmap_leader("xr", '<Cmd>lua MiniSessions.select("read")<CR>', "read")
nmap_leader("xR", "<Cmd>lua MiniSessions.restart()<CR>", "restart")

-- =============================================================================
-- Simplified leader layout
-- =============================================================================
-- <Leader>a  agent (claude/pi tmux pane)
-- <Leader>b  buffers
-- <Leader>c  quickfix/location lists
-- <Leader>e  explore, notifications
-- <Leader>g  git
-- <Leader>l  language, LSP, diagnostics, format, typecheck
-- <Leader>m  minimap
-- <Leader>n  notifications
-- <Leader>o  other/toggles
-- <Leader>s  search/pickers
-- <Leader>x  sessions
