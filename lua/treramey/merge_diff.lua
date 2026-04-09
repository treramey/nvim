local M = {}

local hl = require("treramey.utils").hl_str

local function get_merge_info()
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local merge_head = vim.fn.system("git rev-parse --short MERGE_HEAD 2>/dev/null"):gsub("\n", "")
  local rebase_head = vim.fn.system("git rev-parse --short REBASE_HEAD 2>/dev/null"):gsub("\n", "")
  local cherry_head = vim.fn.system("git rev-parse --short CHERRY_PICK_HEAD 2>/dev/null"):gsub("\n", "")
  local theirs_ref = merge_head ~= "" and merge_head or rebase_head ~= "" and rebase_head or cherry_head
  return branch, theirs_ref or "incoming"
end

local function get_icon(filename)
  local icon, icon_hl = require("mini.icons").get("file", filename)
  return hl(icon_hl, icon .. " ")
end

local function winbar(label, label_hl, ref, filename)
  local icon = get_icon(filename)
  return table.concat({
    hl(label_hl, " " .. label .. " "),
    hl("StatuslineTextAccent", " " .. ref),
    " ",
    icon,
    hl("StatuslineTextMain", filename),
    "%=",
    hl("StatuslineTextAccent", "󰑇 read-only "),
  })
end

local function local_winbar(filename)
  local icon = get_icon(filename)
  return table.concat({
    hl("MergeDiffLocal", " LOCAL "),
    hl("StatuslineTextAccent", " Working Tree"),
    " ",
    icon,
    hl("StatuslineTextMain", filename),
    "%=",
    hl("StatuslineTextAccent", "co ct cb c0 [x ]x "),
  })
end

local function cleanup_stale_buffers(basename)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("^OURS:" .. vim.pesc(basename)) or name:match("^THEIRS:" .. vim.pesc(basename)) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

function M.open()
  local file = vim.fn.expand("%")
  if file == "" then return end
  local ours = vim.fn.system("git show :2:" .. vim.fn.shellescape(file))
  local theirs = vim.fn.system("git show :3:" .. vim.fn.shellescape(file))
  if vim.v.shell_error ~= 0 then
    vim.notify("Not a conflicted file", vim.log.levels.WARN)
    return
  end
  local ft = vim.filetype.match({ filename = file }) or ""
  local basename = vim.fn.fnamemodify(file, ":t")
  local branch, theirs_ref = get_merge_info()
  -- Clean up any stale merge diff buffers for this file
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.b[buf].merge_diff then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
  -- Hide tabline during merge diff
  M._prev_showtabline = vim.o.showtabline
  vim.o.showtabline = 0
  -- Top row: OURS | THEIRS
  vim.cmd("tabnew")
  local ours_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(ours_buf)
  vim.api.nvim_buf_set_lines(ours_buf, 0, -1, false, vim.split(ours, "\n"))
  vim.bo[ours_buf].filetype = ft
  vim.bo[ours_buf].buftype = "nofile"
  vim.api.nvim_buf_set_name(ours_buf, "OURS:" .. basename)
  vim.b[ours_buf].minidiff_disable = true
  vim.b[ours_buf].merge_diff = true
  vim.wo.winbar = winbar("OURS", "MergeDiffOurs", branch, basename)
  vim.wo.winhighlight = "DiffAdd:MergeOursDiffAdd,DiffChange:MergeOursDiffChange,DiffText:MergeOursDiffText,DiffDelete:MergeOursDiffDelete"
  vim.cmd("diffthis")
  vim.cmd("vsplit")
  local theirs_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(theirs_buf)
  vim.api.nvim_buf_set_lines(theirs_buf, 0, -1, false, vim.split(theirs, "\n"))
  vim.bo[theirs_buf].filetype = ft
  vim.bo[theirs_buf].buftype = "nofile"
  vim.api.nvim_buf_set_name(theirs_buf, "THEIRS:" .. basename)
  vim.b[theirs_buf].minidiff_disable = true
  vim.b[theirs_buf].merge_diff = true
  vim.wo.winbar = winbar("THEIRS", "MergeDiffTheirs", theirs_ref, basename)
  vim.wo.winhighlight = "DiffAdd:MergeTheirsDiffAdd,DiffChange:MergeTheirsDiffChange,DiffText:MergeTheirsDiffText,DiffDelete:MergeTheirsDiffDelete"
  vim.cmd("diffthis")
  -- Bottom: LOCAL (working file)
  vim.cmd("botright split " .. vim.fn.fnameescape(file))
  vim.wo.winbar = local_winbar(basename)
  vim.wo.winhighlight = "DiffAdd:MergeLocalDiffAdd,DiffChange:MergeLocalDiffChange,DiffText:MergeLocalDiffText,DiffDelete:MergeLocalDiffDelete"
  vim.cmd("diffthis")
end

function M.close()
  if M._prev_showtabline then
    vim.o.showtabline = M._prev_showtabline
    M._prev_showtabline = nil
  end
  vim.cmd("diffoff!")
  local tab_wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(tab_wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.b[buf].merge_diff then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.cmd("tabclose")
end

return M
