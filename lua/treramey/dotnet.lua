local M = {}
local notify = require "treramey.notify"

function M.setup_env()
  -- Mise (isolated=false) keeps all .NET SDKs under a single DOTNET_ROOT.
  local mise_dotnet_root = vim.fn.expand "~/.local/share/mise/dotnet-root"
  local dotnet_tools = vim.fn.expand "~/.dotnet/tools"
  vim.env.DOTNET_ROOT = mise_dotnet_root
  vim.env.DOTNET_ROOT_X64 = mise_dotnet_root
  vim.env.PATH = mise_dotnet_root .. ":" .. vim.env.PATH
  if vim.fn.isdirectory(dotnet_tools) == 1 then
    vim.env.PATH = dotnet_tools .. ":" .. vim.env.PATH
  end
  vim.env.TMPDIR = vim.env.TMPDIR and vim.fn.resolve(vim.env.TMPDIR) or nil
end

function M.find_project_path()
  local matches = vim.fs.find(function(name)
    return name:match "%.slnx?$" or name:match "%.[cf]sproj$"
  end, { path = vim.fn.getcwd(), upward = true, limit = 1 })

  return matches[1]
end

function M.command_for(path, action, args)
  args = args or ""

  -- stylua: ignore
  local commands = {
    run = function() return string.format("dotnet run --project %s %s", path, args) end,
    test = function() return string.format("dotnet test %s %s", path, args) end,
    restore = function() return string.format("dotnet restore %s %s", path, args) end,
    build = function() return string.format("dotnet build %s %s", path, args) end,
    watch = function() return string.format("dotnet watch --project %s %s", path, args) end,
  }

  return commands[action] and commands[action]()
end

function M.open_terminal(command, opts)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "terminal"

  if opts.float then
    local width = math.floor(vim.o.columns * (opts.width or 0.8))
    local height = math.floor(vim.o.lines * (opts.height or 0.8))
    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      width = width,
      height = height,
      style = "minimal",
      border = opts.border or "rounded",
    })
  else
    vim.cmd "botright split"
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_win_set_height(0, math.max(8, math.floor(vim.o.lines * (opts.height or 0.35))))
  end

  vim.fn.termopen { "bash", "-lc", command }
  vim.cmd "startinsert"
end

function M.easy_dotnet_options()
  return {
    picker = "basic",
    managed_terminal = {
      auto_hide = true,
      auto_hide_delay = 1000,
      mappings = {
        next_tab = { lhs = "<Tab>", desc = "Next terminal tab" },
        prev_tab = { lhs = "<S-Tab>", desc = "Previous terminal tab" },
        new_terminal = { lhs = "+", desc = "New user terminal" },
        close_terminal = { lhs = "X", desc = "Close current terminal tab" },
        hide_panel = { lhs = "q", desc = "Hide terminal panel" },
      },
    },
    debugger = {
      apply_value_converters = true,
      console = "integratedTerminal",
      engine = "netcoredbg",
      auto_register_dap = true,
      mappings = {
        open_variable_viewer = { lhs = "T", desc = "Open variable viewer" },
      },
    },
    server = { use_visual_studio = false, log_level = "Verbose" },
    projx_lsp = { enabled = true },
    lsp = {
      enabled = false,
      roslynator_enabled = false,
      easy_dotnet_analyzer_enabled = false,
      easy_dotnet_extension_enabled = false,
    },
    notifications = {
      handler = notify.dotnet_job_handler,
    },
    auto_bootstrap_namespace = {
      type = "file_scoped",
      enabled = true,
      use_clipboard_json = {
        behavior = "prompt",
        register = "+",
      },
    },
    test_runner = { viewmode = "vsplit", vsplit_width = 70, icons = { project = "󰗀" } },
  }
end

function M.create_user_commands()
  vim.api.nvim_create_user_command("DotnetListPackages", function()
    local path = M.find_project_path() or "."
    M.open_terminal("dotnet list " .. vim.fn.shellescape(path) .. " package --include-transitive; read", {
      float = true,
      width = 0.8,
      height = 0.8,
      border = "rounded",
    })
  end, { desc = "List packages with transitive deps", force = true })

  vim.api.nvim_create_user_command("DotnetLaunchSettings", function()
    local files = vim.fs.find("launchSettings.json", { type = "file", limit = math.huge })
    if #files == 0 then
      vim.notify("[easy-dotnet] No launchSettings.json found", vim.log.levels.WARN)
    elseif #files == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
    else
      vim.ui.select(files, { prompt = "Select launchSettings.json" }, function(choice)
        if choice then
          vim.cmd("edit " .. vim.fn.fnameescape(choice))
        end
      end)
    end
  end, { desc = "Open launchSettings.json", force = true })
end

function M.setup_easy_dotnet()
  M.setup_env()
  require("easy-dotnet").setup(M.easy_dotnet_options())
  M.create_user_commands()
end

local function style_variable_float(float)
  if not float or not float.win or not vim.api.nvim_win_is_valid(float.win) then
    return
  end

  local width = math.min(math.floor(vim.o.columns * 0.68), 118)
  local height = math.min(math.floor(vim.o.lines * 0.58), 28)
  pcall(vim.api.nvim_win_set_config, float.win, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " Variable viewer ",
    title_pos = "left",
    zindex = 60,
  })

  vim.wo[float.win].cursorline = true
  vim.wo[float.win].number = false
  vim.wo[float.win].relativenumber = false
  vim.wo[float.win].wrap = false
  vim.wo[float.win].winblend = 0
  vim.wo[float.win].winhighlight = table.concat({
    "Normal:DapVariableNormal",
    "NormalFloat:DapVariableNormal",
    "FloatBorder:DapVariableBorder",
    "FloatTitle:DapVariableTitle",
    "CursorLine:Visual",
  }, ",")

  if float.buf and vim.api.nvim_buf_is_valid(float.buf) then
    vim.bo[float.buf].filetype = "dap-variable-viewer"
  end
end

local function setup_easy_dotnet_variable_float()
  local ok, variable_float = pcall(require, "easy-dotnet.netcoredbg.debugger-float")
  if not ok or variable_float._treramey_styled then
    return
  end

  local original_show = variable_float.show
  variable_float.show = function(...)
    local float = original_show(...)
    style_variable_float(float)
    return float
  end
  variable_float._treramey_styled = true
end

local easy_dotnet_scope_listener_guarded = false

local function frame_source_path(frame)
  local path = frame and frame.source and frame.source.path
  if type(path) ~= "string" or path == "" then
    return nil
  end

  return path
end

local function frame_line_exists(path, line)
  if type(line) ~= "number" or line < 1 or vim.fn.filereadable(path) ~= 1 then
    return false
  end

  local ok, lines = pcall(vim.fn.readfile, path, "", line)
  return ok and #lines >= line
end

local function read_frame_line(path, line)
  if type(line) ~= "number" or line < 1 or vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  local ok, lines = pcall(vim.fn.readfile, path, "", line)
  if not ok or #lines < line then
    return nil
  end

  return lines[line]
end

local function has_project_file(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  if dir == "" then
    return false
  end

  local matches = vim.fs.find(function(name)
    return name:match "%.[cf]sproj$"
  end, { path = dir, upward = true, limit = 1 })

  return matches[1] ~= nil
end

local function is_netcoredbg_session(session)
  local adapter_command = session and session.adapter and session.adapter.command
  local config_type = session and session.config and session.config.type

  return (type(adapter_command) == "string" and adapter_command:lower():find("netcoredbg", 1, true) ~= nil)
    or config_type == "coreclr"
    or config_type == "easy-dotnet"
end

local function guard_easy_dotnet_scope_listener()
  if easy_dotnet_scope_listener_guarded then
    return
  end

  local dap = require "dap"
  local original = dap.listeners.after.event_stopped["easy-dotnet-scopes"]
  if type(original) ~= "function" then
    return
  end

  dap.listeners.after.event_stopped["easy-dotnet-scopes"] = function(session, body)
    if not is_netcoredbg_session(session) then
      return original(session, body)
    end

    if not body or not body.threadId then
      return
    end

    session:request("stackTrace", { threadId = body.threadId }, function(err, response)
      if err or not response or not response.stackFrames then
        return
      end

      local frame = response.stackFrames[1]
      local path = frame_source_path(frame)
      if not path then
        return
      end

      local max_line = frame.line
      local next_frame = response.stackFrames[2]
      if frame_source_path(next_frame) == path then
        max_line = math.max(max_line or 0, next_frame.line or 0)
      end

      if not frame_line_exists(path, max_line) or not has_project_file(path) then
        return
      end

      pcall(original, session, body)
    end)
  end

  easy_dotnet_scope_listener_guarded = true
end

local netcoredbg_exception_jump_guarded = false

local function project_frame_for_jump(frame)
  local path = frame_source_path(frame)
  if not path or not has_project_file(path) then
    return nil
  end

  local line = tonumber(frame.line)
  line = line and math.floor(line) or nil
  local line_text = read_frame_line(path, line)
  if not line_text then
    return nil
  end

  local jump_frame = vim.deepcopy(frame)
  jump_frame.line = line
  jump_frame.column = math.max(1, math.min(math.floor(tonumber(frame.column) or 1), #line_text + 1))

  return jump_frame
end

local function select_exception_frame(frames)
  local subtle_fallback

  for _, frame in ipairs(frames or {}) do
    local jump_frame = project_frame_for_jump(frame)
    if jump_frame then
      if frame.presentationHint ~= "subtle" then
        return jump_frame
      end

      subtle_fallback = subtle_fallback or jump_frame
    end
  end

  return subtle_fallback
end

local function frame_bufnr(frame)
  local path = frame_source_path(frame)
  if not path then
    return nil
  end

  local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(path))
  vim.fn.bufload(bufnr)
  vim.bo[bufnr].buflisted = true
  return bufnr
end

local function notify_exception_without_source(session, thread_id)
  require("dap.async").run(function()
    if not session.capabilities.supportsExceptionInfoRequest then
      vim.notify("Exception stopped, but no valid project source frame was reported", vim.log.levels.WARN)
      return
    end

    local err, response = session:request("exceptionInfo", { threadId = thread_id })
    if err or not response then
      vim.notify("Exception stopped, but no valid project source frame was reported", vim.log.levels.WARN)
      return
    end

    local details = response.details or {}
    local type_name = details.typeName and (" of type " .. details.typeName) or ""
    local description = response.description and ("\n" .. response.description) or ""
    vim.notify(
      string.format("Thread stopped due to exception%s (%s)%s", type_name, response.breakMode or "unknown", description),
      vim.log.levels.WARN
    )
  end)
end

local function jump_to_exception_source(session, body, frames)
  local frame = select_exception_frame(frames)

  if not frame then
    notify_exception_without_source(session, body.threadId)
    return
  end

  session:_frame_set(frame)

  local bufnr = frame_bufnr(frame)
  if bufnr then
    require("dap.async").run(function()
      session:_show_exception_info(body.threadId, bufnr, frame)
    end)
  end
end

local function guard_netcoredbg_exception_jump()
  if netcoredbg_exception_jump_guarded then
    return
  end

  local pending_exception_threads = setmetatable({}, { __mode = "k" })

  require("dap").listeners.before.event_stopped["netcoredbg-exception-preserve-focus"] = function(session, body)
    if body and body.reason == "exception" and is_netcoredbg_session(session) then
      body.preserveFocusHint = true

      if body.threadId then
        pending_exception_threads[session] = body.threadId
      end
    end
  end

  require("dap").listeners.after.stackTrace["netcoredbg-exception-smart-jump"] = function(
    session,
    err,
    response,
    request
  )
    local pending_thread_id = pending_exception_threads[session]
    if not pending_thread_id or not request or request.threadId ~= pending_thread_id or request.startFrame ~= 0 then
      return
    end

    pending_exception_threads[session] = nil

    if err or not response or not is_netcoredbg_session(session) then
      notify_exception_without_source(session, pending_thread_id)
      return
    end

    jump_to_exception_source(session, { threadId = pending_thread_id }, response.stackFrames)
  end

  netcoredbg_exception_jump_guarded = true
end

function M.setup_dap_integration()
  require("easy-dotnet.netcoredbg").register_dap_variables_viewer()
  guard_netcoredbg_exception_jump()
  guard_easy_dotnet_scope_listener()
  setup_easy_dotnet_variable_float()
end

return M
