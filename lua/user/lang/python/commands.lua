local M = {}
local nnoremap = require("user.keymap_utils").nnoremap

nnoremap("<leader>rp", function()
	vim.cmd("update")

	local current_file = vim.fn.expand("%")
	local file_extension = current_file:match("^.+(%..+)$")

	if file_extension ~= ".py" then
		vim.notify("The current file is not a Python file.", 4)
		return
	end

	local cmd = "python " .. current_file
	local terminal_opts = {
		win = {
			position = "bottom",
			height = 0.20,
		},
	}

	require("snacks.terminal").toggle(cmd, terminal_opts)
end)

return M
