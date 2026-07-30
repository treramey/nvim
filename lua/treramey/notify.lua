local M = {}

local function hidden_display()
  return nil
end

local function clean_update_hook(item)
  if item.annote == "" then
    item.annote = nil
  end

  require("fidget.notification").set_content_key(item)
end

local function notification_config()
  local config = vim.deepcopy(require("fidget.notification").default_config)
  config.name = nil
  config.icon = nil
  config.info_annote = ""
  config.render_limit = 3
  config.update_hook = clean_update_hook
  return config
end

local function lsp_progress_config()
  local config = notification_config()
  config.name = hidden_display
  config.icon = hidden_display
  config.priority = 30
  config.skip_history = false
  config.ttl = 2
  return config
end

local function coerce_progress_text(text)
  if type(text) == "string" then
    return text
  end

  if type(text) == "table" then
    local parts = {}
    for _, chunk in ipairs(text) do
      if type(chunk) == "string" then
        table.insert(parts, chunk)
      elseif type(chunk) == "table" and type(chunk[1]) == "string" then
        table.insert(parts, chunk[1])
      end
    end

    local value = table.concat(parts)
    return value ~= "" and value or nil
  end

  if text ~= nil then
    return tostring(text)
  end
end

local function format_progress_message(message)
  local text = coerce_progress_text(message.message)
  if not text or text == "" then
    text = message.done and "Completed" or "In progress..."
  end

  local title = type(message.title) == "string" and message.title or nil
  if message.done and title and title ~= "" and not text:lower():find(title:lower(), 1, true) then
    text = title .. ": " .. text
  end

  if type(message.percentage) == "number" then
    text = string.format("%s (%.0f%%)", text, message.percentage)
  end

  return text
end

local function format_progress_annote(message)
  local title = type(message.title) == "string" and message.title or nil
  if not title or title == "" then
    return ""
  end

  if message.done then
    return ""
  end

  local text = coerce_progress_text(message.message)
  if text and text:lower():find(title:lower(), 1, true) then
    return ""
  end

  return title
end

local function history_group(item)
  if item.group_name and item.group_name ~= "" then
    return item.group_name
  end

  if item.group_key == "default" then
    return nil
  end

  return item.group_key
end

local function format_history_item(item)
  local message_lines = vim.split(item.message, "\n", { plain = true, trimempty = false })

  local parts = { os.date("%Y-%m-%d %H:%M:%S", item.last_updated) }
  if item.annote and item.annote ~= "" then
    table.insert(parts, item.annote)
  end

  local group = history_group(item)
  if group and group ~= "" then
    table.insert(parts, group)
  end
  if item.removed == false then
    table.insert(parts, "active")
  end

  local lines = { table.concat(parts, " | ") .. " | " .. message_lines[1] }
  for index = 2, #message_lines do
    table.insert(lines, "  " .. message_lines[index])
  end

  return lines
end

local function history_lines(items)
  local lines = {}

  if vim.tbl_isempty(items) then
    table.insert(lines, "No Fidget notification history.")
    return lines
  end

  table.sort(items, function(a, b)
    return a.last_updated > b.last_updated
  end)

  for index, item in ipairs(items) do
    vim.list_extend(lines, format_history_item(item))
    if index < #items then
      table.insert(lines, "")
    end
  end

  return lines
end

local function message_history_lines()
  local messages = vim.fn.execute "messages"
  local lines = vim.split(messages, "\n", { plain = true, trimempty = true })
  if vim.tbl_isempty(lines) then
    return { "No Neovim message history." }
  end

  return lines
end

local function combined_history_lines()
  local lines = {
    "Fidget notifications",
    string.rep("=", 20),
  }
  vim.list_extend(lines, history_lines(require("fidget.notification").get_history()))
  vim.list_extend(lines, {
    "",
    "Neovim messages",
    string.rep("=", 15),
  })
  vim.list_extend(lines, message_history_lines())
  return lines
end

function M.setup()
  require("fidget").setup {
    progress = {
      clear_on_detach = false,
      notification_group = function()
        return "lsp_progress"
      end,
      display = {
        done_ttl = 2,
        format_message = format_progress_message,
        format_annote = format_progress_annote,
        format_group_name = hidden_display,
        progress_icon = { pattern = "dots_negative" },
        skip_history = false,
        overrides = {
          lsp_progress = {
            name = hidden_display,
            icon = hidden_display,
            info_annote = "",
            update_hook = clean_update_hook,
            skip_history = false,
          },
        },
      },
    },
    notification = {
      configs = {
        default = notification_config(),
        lsp_progress = lsp_progress_config(),
      },
      override_vim_notify = true,
      view = {
        group_separator = "",
      },
      window = {
        winblend = 0,
      },
    },
  }
end

function M.show_history()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "notify"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_name(buf, "notification-history://" .. buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, combined_history_lines())
  vim.bo[buf].modifiable = false

  vim.cmd "botright split"
  vim.api.nvim_win_set_buf(0, buf)
  vim.wo.wrap = true
end

function M.dotnet_job_handler(start_event)
  local handle = require("fidget.progress").handle.create {
    title = start_event.job.name,
    message = "Running...",
    lsp_client = { name = "easy-dotnet" },
  }

  return function(finished_event)
    handle.message = finished_event.result.msg
    handle:finish()
  end
end

return M
