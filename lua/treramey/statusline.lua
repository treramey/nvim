local M = {}
local state = {
	cache = {
		diagnostics = "",
		last_update = 0,
	},
	spinner_chars = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
	codecompanion = {
		status = nil, -- "thinking", "streaming"
		spinner_index = 1,
	},
}

---@param n number
---@return string
local function _spacer(n)
	local spaces = string.rep(" ", n)
	return "%#StatuslineTextMain#" .. spaces
end

local function _align()
	return "%="
end

---@param side "left" | "right"
---@return string
local function _separator(side)
	if side == "right" then
		return "%#StatuslineSeparator#" .. ""
	end
	return "%#StatuslineSeparator#" .. ""
end

-- From TJDevries
-- https://github.com/tjdevries/lazy-require.nvim
local function lazy_require(require_path)
	return setmetatable({}, {
		__index = function(_, key)
			return require(require_path)[key]
		end,

		__newindex = function(_, key, value)
			require(require_path)[key] = value
		end,
	})
end

local is_truncated = function(trunc_width)
	local cur_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
	return cur_width < (trunc_width or -1)
end

local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

local modes = setmetatable({
	["n"] = { long = "NORMAL", short = "N", hl = "%#StatuslineModeNormal#" },
	["v"] = { long = "VISUAL", short = "V", hl = "%#StatuslineModeVisual#" },
	["V"] = { long = "V-LINE", short = "V-L", hl = "%#StatuslineModeVisual#" },
	[CTRL_V] = { long = "V-BLOCK", short = "V-B", hl = "%#StatuslineModeVisual#" },
	["s"] = { long = "SELECT", short = "S", hl = "%#StatuslineModeVisual#" },
	["S"] = { long = "S-LINE", short = "S-L", hl = "%#StatuslineModeVisual#" },
	[CTRL_S] = { long = "S-BLOCK", short = "S-B", hl = "%#StatuslineModeVisual#" },
	["i"] = { long = "INSERT", short = "I", hl = "%#StatuslineModeInsert#" },
	["R"] = { long = "REPLACE", short = "R", hl = "%#StatuslineModeReplace#" },
	["c"] = { long = "COMMAND", short = "C", hl = "%#StatuslineModeCommand#" },
	["r"] = { long = "PROMPT", short = "P", hl = "%#StatuslineModeOther#" },
	["!"] = { long = "SHELL", short = "Sh", hl = "%#StatuslineModeOther#" },
	["t"] = { long = "TERMINAL", short = "T", hl = "%#StatuslineModeOther#" },
}, {
	__index = function()
		return { long = "Unknown", short = "U", hl = "%#StatuslineModeOther#" }
	end,
})

local function get_mode()
	local mode_info = modes[vim.fn.mode()]
	local mode = is_truncated(120) and mode_info.short or mode_info.long
	return mode_info.hl .. " " .. mode .. " " .. _spacer(1)
end

local function get_lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	local hl = "%#StatuslineLspOn#"
	if #clients > 0 and clients[1].initialized then
		return hl .. " " .. _spacer(1)
	else
		return ""
	end
end

local function get_formatter_status()
	local hl = "%#StatuslineFormatterStatus#"
	local conform = lazy_require("conform")

	local formatters = conform.list_formatters(0)
	if #formatters > 0 then
		return hl .. "" .. _spacer(2)
	else
		return ""
	end
end

local function get_copilot_status()
	local hl_copilot = "%#StatuslineCopilot#"
	local ok, c = pcall(lazy_require, "copilot.client")
	if not ok then
		return ""
	end
	ok = not c.is_disabled() and c.buf_is_attached(vim.api.nvim_get_current_buf())
	if not ok then
		return ""
	end
	return hl_copilot .. " " .. _spacer(1)
end

local function get_harpoon_status()
	local harpoon = require("harpoon")
	local entries = harpoon:list()
	local count = 0

	-- Iterate through all harpoon entries and count the valid ones.
	for i = 1, entries:length() do
		local entry = entries:get(i)
		if entry and entry.value then
			count = count + 1
		end
	end

	-- If there are no entries, return an empty string.
	if count == 0 then
		return ""
	end

	local hl_main = "%#StatuslineActiveHarpoon#"
	-- Return the status string with the  icon and the count.
	return hl_main .. " " .. count .. _spacer(1)
end

local function get_diagnostics()
	if state.cache.diagnostics and vim.loop.now() - state.cache.last_update < 100 then
		return state.cache.diagnostics
	end

	local severities = {
		{ name = "E", hl = "%#StatuslineDiagnosticError#" },
		{ name = "W", hl = "%#StatuslineDiagnosticWarn#" },
		{ name = "I", hl = "%#StatuslineDiagnosticInfo#" },
		{ name = "H", hl = "%#StatuslineDiagnosticHint#" },
	}

	local result = ""
	local diag_count = 0

	for _, severity in ipairs(severities) do
		local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity.name] })
		if count > 0 then
			result = result .. severity.hl .. " " .. count .. _spacer(1)
			diag_count = 1
		end
	end

	local ret = result .. _spacer(diag_count)
	state.cache.diagnostics = ret
	return ret
end

local function get_dotnet_solution()
	local hl_main = "%#StatuslineTextMain#"
	local solution = vim.fs.basename(vim.g.roslyn_nvim_selected_solution)
	if solution == nil then
		return ""
	end
	solution = solution:gsub("%.[^%.]+$", "")
	local icon, hl, _ = require("mini.icons").get("filetype", "solution")
	local hl_base = "%#StatuslineSolution#"
	return hl_base .. icon .. " " .. hl_main .. solution .. _spacer(2)
end

local function get_recording()
	local hl_main = "%#StatuslineTextMain#"
	local hl_icon = "%#StatuslineRec#"
	local noice = lazy_require("noice")
	local status = noice.api.status.mode.get()
	if status == nil then
		return ""
	end
	return hl_icon .. "󰻂 " .. hl_main .. status .. _spacer(2)
end

local function get_branch()
	if is_truncated(40) then
		return ""
	end
	local branch = vim.b.minigit_summary_string or ""
	local hl_main = "%#StatuslineTextMain#"
	local hl_accent = "%#StatuslineTextAccent#"
	if branch == "" then
		return ""
	end
	return hl_accent .. " " .. hl_main .. branch .. _spacer(2)
end

local function get_codecompanion_status()
	if not state.codecompanion.status then
		return ""
	end
	local index = state.codecompanion.spinner_index
	local spinner_char = state.spinner_chars[index]
	local status_text = state.codecompanion.status == "thinking" and " ai is thinking" or " ai is responding"

	return "%#StatuslineSpinner#" .. spinner_char .. "%#StatuslineTextAccent#" .. status_text .. _spacer(2)
end

local function get_scrollbar()
	if is_truncated(75) then
		return ""
	end

	local sbar_chars = { "▔", "🮂", "🬂", "🮃", "▀", "▄", "▃", "🬭", "▂", "▁" }

	local cur_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_line_count(0)

	local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
	local sbar = string.rep(sbar_chars[i], 2)

	return "%#StatuslineScrollbar#" .. sbar .. _spacer(1)
end

M.setup = function()
	vim.opt.laststatus = 3
	vim.opt.showmode = false
end

M.load = function()
	local curr_ft = vim.bo.filetype
	local disabled_filetypes = {
		"dashboard",
	}

	if vim.tbl_contains(disabled_filetypes, curr_ft) then
		return nil
	end

	return table.concat({
		_align(),
		_separator("left"),
		get_mode(),
		get_lsp_status(),
		get_formatter_status(),
		get_copilot_status(),
		get_harpoon_status(),
		get_diagnostics(),
		get_recording(),
		get_codecompanion_status(),
		get_dotnet_solution(),
		get_branch(),
		get_scrollbar(),
		_separator("right"),
		_align(),
	})
end

vim.api.nvim_create_augroup("Statusline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = "Statusline",
	pattern = "*",
	callback = function()
		vim.o.statusline = "%!v:lua.require'treramey.statusline'.load()"
	end,
})

local global_timer = nil

local function codecompanion_spinner()
	global_timer = vim.loop.new_timer()
	if global_timer == nil then
		vim.notify("Failed to create global timer for statusline spinner", vim.log.levels.ERROR)
		return
	end
	global_timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			if state.codecompanion.status == nil then
				global_timer:stop()
				return
			end
			state.codecompanion.spinner_index = (state.codecompanion.spinner_index % #state.spinner_chars) + 1
			vim.o.statusline = "%!v:lua.require'treramey.statusline'.load()"
		end)
	)
end

local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "CodeCompanionRequest*",
	group = group,
	callback = function(request)
		if request.match == "CodeCompanionRequestStarted" then
			state.codecompanion.status = "thinking"
			codecompanion_spinner()
		elseif request.match == "CodeCompanionRequestStreaming" then
			state.codecompanion.status = "streaming"
			codecompanion_spinner()
		elseif request.match == "CodeCompanionRequestFinished" then
			state.codecompanion.status = nil
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		if global_timer then
			global_timer:stop()
			global_timer:close()
		end
	end,
})

return M
