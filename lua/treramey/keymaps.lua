local harpoon = require("harpoon")
local conform = require("conform")
local smart_splits = require("smart-splits")
local twoslash = require("twoslash-queries")
local snacks = require("snacks")
local prelude = require("treramey.prelude")
local copy_line_diagnostics_to_clipboard = prelude.copy_line_diagnostics_to_clipboard
local open_link = prelude.open_link

local M = {}

-- Harpoon setup --
harpoon:setup({})

-- Normal Mode --
vim.keymap.set("n", "<space>", "<nop>", { desc = "Disable space (leader) in normal mode" })

vim.keymap.set("n", "<C-/>", "<nop>")

-- Window and smart-splits navigation
vim.keymap.set("n", "<C-j>", function()
	smart_splits.move_cursor_down()
end, { desc = "Navigate down" })

vim.keymap.set("n", "<C-k>", function()
	smart_splits.move_cursor_up()
end, { desc = "Navigate up" })

vim.keymap.set("n", "<C-l>", function()
	smart_splits.move_cursor_right()
end, { desc = "Navigate right" })

vim.keymap.set("n", "<C-h>", function()
	smart_splits.move_cursor_left()
end, { desc = "Navigate left" })

-- Swap between last two buffers
vim.keymap.set("n", "<leader>'", "<C-^>", { desc = "Switch to last buffer" })

-- Save and Quit
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false, desc = "Save current buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false, desc = "Quit current buffer" })

-- Map Oil to <leader>e
vim.keymap.set("n", "<leader>e", function()
	require("oil").toggle_float()
end, { desc = "Toggle Oil file explorer" })

-- Map Undotree
vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>", { desc = "Toggle UndoTree" })

-- InspectTwoslashQueries
vim.keymap.set("n", "<leader>ti", ":InspectTwoslashQueries<CR>", { desc = "[I]nspect [T]woslash Query" })

-- Center buffer while navigating
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "{", "{zz", { desc = "Jump to previous paragraph and center" })
vim.keymap.set("n", "}", "}zz", { desc = "Jump to next paragraph and center" })
vim.keymap.set("n", "N", "Nzz", { desc = "Search previous and center" })
vim.keymap.set("n", "n", "nzz", { desc = "Search next and center" })
vim.keymap.set("n", "G", "Gzz", { desc = "Go to end of file and center" })
vim.keymap.set("n", "gg", "ggzz", { desc = "Go to beginning of file and center" })
vim.keymap.set("n", "gd", "gdzz", { desc = "Go to definition and center" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "Jump forward in jump list and center" })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Jump backward in jump list and center" })
vim.keymap.set("n", "%", "%zz", { desc = "Jump to matching bracket and center" })
vim.keymap.set("n", "*", "*zz", { desc = "Search for word under cursor and center" })
vim.keymap.set("n", "#", "#zz", { desc = "Search backward for word under cursor and center" })

-- Quick find/replace for word under cursor
vim.keymap.set("n", "S", function()
	local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end, { desc = "Quick find/replace word under cursor" })

-- Grug-far for global find/replace
vim.keymap.set("n", "<leader>S", function()
	local grug = require("grug-far")
	local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
	grug.open({
		transient = true,
		prefills = {
			filesFilter = ext and ext ~= "" and "*." .. ext or nil,
		},
	})
end, { desc = "Open grug-far for search and replace" })

-- Jump to start/end of line
vim.keymap.set("n", "L", "$", { desc = "Jump to end of line" })
vim.keymap.set("n", "H", "^", { desc = "Jump to beginning of line" })

-- Redo last change
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo last change" })

-- Turn off highlighted search results
vim.keymap.set("n", "<leader>no", "<cmd>noh<cr>", { desc = "Toggle search highlighting" })

vim.keymap.set("n", "<leader>ts", function()
	if twoslash.config.is_enabled then
		vim.cmd("TwoslashQueriesDisable")
		snacks.notify.info("Two Slash queries disabled")
		return
	end

	vim.cmd(":TwoslashQueriesEnable")
	snacks.notify.info("Two Slash queries enabled")
end, { desc = "Toggle [T]wo [S]lash queries" })

-- Diagnostics --
vim.keymap.set("n", "]d", function()
	local ok = pcall(vim.diagnostic.jump, { count = 1, float = true })
	if ok then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end, { desc = "Go to next diagnostic and center" })

vim.keymap.set("n", "[d", function()
	local ok = pcall(vim.diagnostic.jump, { count = -1, float = true })
	if ok then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end, { desc = "Go to previous diagnostic and center" })

vim.keymap.set("n", "]e", function()
	local ok = pcall(vim.diagnostic.jump, { count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
	if ok then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end, { desc = "Go to next error diagnostic and center" })

vim.keymap.set("n", "[e", function()
	local ok = pcall(vim.diagnostic.jump, { count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
	if ok then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end, { desc = "Go to previous error diagnostic and center" })

vim.keymap.set("n", "]w", function()
	local ok = pcall(vim.diagnostic.jump, { count = 1, severity = vim.diagnostic.severity.WARN, float = true })
	if ok then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end, { desc = "Go to next warning diagnostic and center" })

vim.keymap.set("n", "[w", function()
	local ok = pcall(vim.diagnostic.jump, { count = -1, severity = vim.diagnostic.severity.WARN, float = true })
	if ok then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end, { desc = "Go to previous warning diagnostic and center" })

-- Diagnostic float and quickfix
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Open diagnostic float with rounded border" })

vim.keymap.set("n", "<leader>cd", copy_line_diagnostics_to_clipboard, { desc = "[C]opy line [D]iagnostics" })

vim.keymap.set("n", "<leader>ld", vim.diagnostic.setqflist, { desc = "Populate quickfix list with diagnostics" })

-- Quickfix navigation
vim.keymap.set("n", "<leader>cn", ":cnext<cr>zz", { desc = "Go to next quickfix item and center" })
vim.keymap.set("n", "<leader>cp", ":cprevious<cr>zz", { desc = "Go to previous quickfix item and center" })
vim.keymap.set("n", "<leader>co", ":copen<cr>zz", { desc = "Open quickfix list and center" })
vim.keymap.set("n", "<leader>cc", ":cclose<cr>zz", { desc = "Close quickfix list" })

-- Maximizer toggle and window resize
vim.keymap.set("n", "<leader>m", ":MaximizerToggle<cr>", { desc = "Toggle window maximization" })
vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Equalize split window sizes" })

-- Format current buffer
vim.keymap.set("n", "<leader>f", function()
	conform.format({
		async = true,
		timeout_ms = 500,
		lsp_format = "fallback",
	})
end, { desc = "Format the current buffer" })

-- Rotate open windows
vim.keymap.set("n", "<leader>rw", ":RotateWindows<cr>", { desc = "Rotate open windows" })

-- Open link under cursor (supports markdown links and links in parens)
vim.keymap.set("n", "gx", open_link, { silent = true, desc = "Open link under cursor (supports markdown and parens)" })

-- Run TypeScript compiler
vim.keymap.set("n", "<leader>tc", ":TSC<cr>", { desc = "Run TypeScript compile" })

-- Harpoon keybinds (v2 API) --
vim.keymap.set("n", "<leader>ho", function()
	harpoon.ui:toggle_quick_menu(harpoon:list(), {
		ui_max_width = 75,
		border = "rounded",
		title = " Harpoon ",
		title_pos = "center",
	})
end, { desc = "Toggle Harpoon quick menu" })

vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Add current file to Harpoon" })

vim.keymap.set("n", "<leader>hr", function()
	harpoon:list():remove()
end, { desc = "Remove current file from Harpoon" })

vim.keymap.set("n", "<leader>hc", function()
	harpoon:list():clear()
end, { desc = "Clear all Harpoon marks" })

vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Navigate to Harpoon file 1" })

vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Navigate to Harpoon file 2" })

vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Navigate to Harpoon file 3" })

vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Navigate to Harpoon file 4" })

vim.keymap.set("n", "<leader>5", function()
	harpoon:list():select(5)
end, { desc = "Navigate to Harpoon file 5" })

-- Snacks picker keybinds --
vim.keymap.set("n", "<leader>?", function()
	snacks.picker.recent()
end, { desc = "Find recently opened files" })

vim.keymap.set("n", "<leader>sb", function()
	snacks.picker.buffers()
end, { desc = "Search open buffers" })

vim.keymap.set("n", "<leader>sf", function()
	-- if vim.g.roslyn_nvim_selected_solution then
	-- 	local ok, projects = pcall(require("roslyn.sln.api").projects, vim.g.roslyn_nvim_selected_solution)
	-- 	if ok and projects and #projects > 0 then
	-- 		local dirs = {}
	-- 		local seen = {}
	--
	-- 		for _, project in ipairs(projects) do
	-- 			local dir = vim.fs.dirname(project)
	-- 			if dir and not seen[dir] and vim.fn.isdirectory(dir) == 1 then
	-- 				dirs[#dirs + 1] = dir
	-- 				seen[dir] = true
	-- 			end
	-- 		end
	--
	-- 		if #dirs > 0 then
	-- 			snacks.picker.files({
	-- 				dirs = dirs,
	-- 				hidden = true,
	-- 			})
	-- 			return
	-- 		end
	-- 	end
	-- end

	-- Fallback to regular file picker
	snacks.picker.files({
		hidden = true,
	})
end, { desc = "Find files (solution-aware)" })

vim.keymap.set("n", "<leader>sh", function()
	snacks.picker.help()
end, { desc = "Search help tags" })

vim.keymap.set("n", "<leader>sg", function()
	snacks.picker.grep()
end, { desc = "Live grep search" })

vim.keymap.set("v", "<leader>sg", function()
	snacks.picker.grep_word()
end, { desc = "Grep selection" })

vim.keymap.set("n", "<leader>sw", function()
	snacks.picker.grep_word()
end, { desc = "Search current word" })

vim.keymap.set("n", "<leader>sc", function()
	snacks.picker.git_log_file()
end, { desc = "[S]earch buffer [C]ommits" })

vim.keymap.set("n", "<leader>/", function()
	snacks.picker.grep_buffers()
end, { desc = "Fuzzily search in current buffer" })

-- LSP Symbol search
vim.keymap.set("n", "<leader>ss", function()
	snacks.picker.lsp_symbols()
end, { desc = "LSP document symbols" })

vim.keymap.set("n", "<leader>sS", function()
	snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP workspace symbols" })

-- TODO Comments
vim.keymap.set("n", "<leader>st", function()
	snacks.picker.todo_comments()
end, { desc = "[S]earch [T]ODOs" })

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Jump to next TODO" })

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Jump to previous TODO" })

-- LSP Keybinds (per-buffer)
M.map_lsp_keybinds = function(buffer_number)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol", buffer = buffer_number })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action", buffer = buffer_number })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition", buffer = buffer_number })
	vim.keymap.set("n", "gr", function()
		snacks.picker.lsp_references()
	end, { desc = "LSP: Go to references", buffer = buffer_number })
	vim.keymap.set("n", "gi", function()
		snacks.picker.lsp_implementations()
	end, { desc = "LSP: Go to implementations", buffer = buffer_number })

	local signature_help = function()
		return vim.lsp.buf.signature_help({ border = "rounded" })
	end

	local hover = function()
		return vim.lsp.buf.hover({ border = "rounded" })
	end

	vim.keymap.set("n", "K", hover, { desc = "LSP: Hover documentation", buffer = buffer_number })
	vim.keymap.set("i", "<C-k>", signature_help, { desc = "LSP: Signature help", buffer = buffer_number })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration", buffer = buffer_number })
	vim.keymap.set("n", "td", vim.lsp.buf.type_definition, { desc = "LSP: Type definition", buffer = buffer_number })
end

-- Symbol Outline keybind
vim.keymap.set("n", "<leader>so", ":Outline<cr>", { desc = "Toggle symbol outline" })

-- Insert Mode --
vim.keymap.set("i", "jj", "<esc>", { desc = "Exit insert mode (jj)" })
vim.keymap.set("i", "JJ", "<esc>", { desc = "Exit insert mode (JJ)" })

-- Visual Mode --
vim.keymap.set("v", "<space>", "<nop>", { desc = "Disable space (leader) in visual mode" })
vim.keymap.set("v", "L", "$<left>", { desc = "Move to end of line in visual mode" })
vim.keymap.set("v", "H", "^", { desc = "Move to beginning of line in visual mode" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected block down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected block up" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })

-- This keymap indents the selected visual block to the left and reselects it
vim.keymap.set("x", "<<", function()
	vim.cmd("normal! <<")
	vim.cmd("normal! gv")
end, { desc = "Indent left and reselect visual block" })

vim.keymap.set("x", ">>", function()
	vim.cmd("normal! >>")
	vim.cmd("normal! gv")
end, { desc = "Indent right and reselect visual block" })

-- Terminal --
-- Enter normal mode while in a terminal
vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]])

-- Window navigation from terminal
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

-- Reenable default <space> functionality to prevent input delay
vim.keymap.set("t", "<space>", "<space>")

return M
