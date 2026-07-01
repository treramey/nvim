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
  config.skip_history = true
  config.ttl = 2
  return config
end

local function format_progress_annote(message)
  if not message.title or message.title == "" then
    return ""
  end

  if message.done then
    return ""
  end

  if message.message and message.message:lower():find(message.title:lower(), 1, true) then
    return ""
  end

  return message.title
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
        format_annote = format_progress_annote,
        format_group_name = hidden_display,
        progress_icon = { pattern = "dots_negative" },
        overrides = {
          lsp_progress = {
            name = hidden_display,
            icon = hidden_display,
            info_annote = "",
            update_hook = clean_update_hook,
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
  vim.cmd "Fidget history"
end

function M.dotnet_job_handler(start_event)
  local handle = require("fidget.progress").handle.create {
    title = start_event.job.name,
    message = "Running...",
    lsp_client = { name = "easy-dotnet" },
  }

  return function(finished_event)
    if handle == nil then
      return
    end

    handle.message = finished_event.result.msg
    handle:finish()
  end
end

return M
