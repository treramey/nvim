local M = {}

M.hl_str = function(group, str)
	return string.format("%%#%s#%s%%*", group, str)
end

M.root = function()
	local git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(git_path, ":h")
end

return M
