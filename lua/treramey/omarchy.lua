local M = {}

M.watch_dir = vim.fn.expand("~/.config/omarchy/current")
M.theme_file = M.watch_dir .. "/theme/neovim.lua"

function M.is_active()
	return vim.fn.isdirectory(M.watch_dir) == 1
end

function M.get_colorscheme()
	local ok, spec = pcall(dofile, M.theme_file)
	if not ok or type(spec) ~= "table" then
		return nil
	end
	for _, entry in ipairs(type(spec[1]) == "string" and { spec } or spec) do
		if entry[1] == "LazyVim/LazyVim" then
			return entry.opts and entry.opts.colorscheme
		end
	end
end

function M.apply_colorscheme(name)
	pcall(require("lazy.core.loader").colorscheme, name)
	vim.cmd.colorscheme(name)
end

function M.setup()
	if not M.is_active() then
		return
	end

	local uv = vim.uv or vim.loop
	local handle = uv.new_fs_event()
	local timer = uv.new_timer()
	if not handle or not timer then
		return
	end

	handle:start(M.watch_dir, {}, function(err)
		if err then
			return
		end
		timer:stop()
		timer:start(200, 0, vim.schedule_wrap(function()
			local colorscheme = M.get_colorscheme()
			if colorscheme then
				M.apply_colorscheme(colorscheme)
				vim.cmd("redraw!")
			end
		end))
	end)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			timer:stop()
			timer:close()
			handle:stop()
			handle:close()
		end,
	})
end

return M
