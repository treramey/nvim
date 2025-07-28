local harpoon = require("harpoon")
local conform = require("conform")
local smart_splits = require("smart-splits")
local twoslash = require("twoslash-queries")
local snacks = require("snacks")

local M = {}

-- Harpoon setup --
harpoon:setup({})

-- Normal --
-- Disable Space bar since it'll be used as the leader key
vim.keymap.set("n", "<space>", "<nop>")

-- Window +  better navigation
vim.keymap.set("n", "<C-h>", function()
	smart_splits.move_cursor_left()
end)

vim.keymap.set("n", "<C-j>", function()
	smart_splits.move_cursor_down()
end)

vim.keymap.set("n", "<C-k>", function()
	smart_splits.move_cursor_up()
end)

vim.keymap.set("n", "<C-l>", function()
	smart_splits.move_cursor_right()
end)

-- Select all and yank with Ctrl-a
-- vim.keymap.set("n", "<C-a>", "ggVGy", { desc = "Select all and yank" })

-- Swap between last two buffers
vim.keymap.set("n", "<leader>'", "<C-^>", { desc = "Switch to last buffer" })

-- Save and quit
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false })

-- Map Oil to <leader>e
vim.keymap.set("n", "<leader>e", function()
	require("oil").toggle_float()
end)

-- Map Undotree to <leader>
vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>", { desc = "Toggle [U]ndo[T]ree " })

-- InspectTwoslashQueries
vim.keymap.set("n", "<leader>ti", ":InspectTwoslashQueries<CR>", { desc = "[I]nspect [T]woslash Query" })

-- Center buffer while navigating
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "gg", "ggzz")
vim.keymap.set("n", "gd", "gdzz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- Press 'S' for quick find/replace for the word under the cursor
vim.keymap.set("n", "S", function()
	local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end)

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "H", "^")

-- Press 'U' for redo
vim.keymap.set("n", "U", "<C-r>")

-- Turn off highlighted results
vim.keymap.set("n", "<leader>no", "<cmd>noh<cr>")

-- Diagnostics
-- Goto next diagnostic of any severity
vim.keymap.set("n", "]d", function()
	local success = pcall(vim.diagnostic.jump, { count = 1, float = true })
	if success then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end)

-- Goto previous diagnostic of any severity
vim.keymap.set("n", "[d", function()
	local success = pcall(vim.diagnostic.jump, { count = -1, float = true })
	if success then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end)

-- Goto next error diagnostic
vim.keymap.set("n", "]e", function()
	local success = pcall(vim.diagnostic.jump, { count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
	if success then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end)

-- Goto previous error diagnostic
vim.keymap.set("n", "[e", function()
	local success = pcall(vim.diagnostic.jump, { count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
	if success then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end)

-- Goto next warning diagnostic
vim.keymap.set("n", "]w", function()
	local success = pcall(vim.diagnostic.jump, { count = 1, float = true, severity = vim.diagnostic.severity.WARN })
	if success then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end)

-- Goto previous warning diagnostic
vim.keymap.set("n", "[w", function()
	local success = pcall(vim.diagnostic.jump, { count = -1, float = true, severity = vim.diagnostic.severity.WARN })
	if success then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end)

-- Open the diagnostic under the cursor in a float window
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float({
		border = "rounded",
	})
end)

-- Navigate to next qflist item
vim.keymap.set("n", "<leader>cn", ":cnext<cr>zz")

-- Navigate to previos qflist item
vim.keymap.set("n", "<leader>cp", ":cprevious<cr>zz")

-- Open the qflist
vim.keymap.set("n", "<leader>co", ":copen<cr>zz")

-- Close the qflist
vim.keymap.set("n", "<leader>cc", ":cclose<cr>zz")

-- Map MaximizerToggle (szw/vim-maximizer) to leader-m
vim.keymap.set("n", "<leader>m", ":MaximizerToggle<cr>")

-- Resize split windows to be equal size
vim.keymap.set("n", "<leader>=", "<C-w>=")

-- Press leader f to format
vim.keymap.set("n", "<leader>f", function()
	conform.format({
		async = true,
		timeout_ms = 500,
		lsp_format = "fallback",
	})
end, { desc = "Format the current buffer" })

-- Press leader rw to rotate open windows
vim.keymap.set("n", "<leader>rw", ":RotateWindows<cr>", { desc = "[R]otate [W]indows" })

-- Press gx to open the link under the cursor
vim.keymap.set("n", "gx", ":sil !open <cWORD><cr>", { silent = true })

-- TSC autocommand keybind to run TypeScripts tsc
vim.keymap.set("n", "<leader>tc", ":TSC<cr>", { desc = "[T]ypeScript [C]ompile" })

-- Harpoon keybinds --
-- Open harpoon ui
vim.keymap.set("n", "<leader>ho", function()
	harpoon.ui:toggle_quick_menu(harpoon:list(), {
		ui_max_width = 75,
		border = "rounded",
		title = " Harpoon ",
		title_pos = "center",
	})
end)

-- Add current file to harpoon
vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end)

-- Remove current file from harpoon
vim.keymap.set("n", "<leader>hr", function()
	harpoon:list():remove()
end)

-- Remove all files from harpoon
vim.keymap.set("n", "<leader>hc", function()
	harpoon:list():clear()
end)

-- Quickly jump to harpooned files
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end)

vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end)

vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end)

vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end)

vim.keymap.set("n", "<leader>5", function()
	harpoon:list():select(5)
end)

-- Telescope keybinds --
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch Open [B]uffers" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>st", ":TodoTelescope<CR>", { desc = "[S]earch TODOs" })

vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>fl", ":TodoQuickFix<CR>", { desc = "[F]ind [L]ines with TODOs" })

-- LSP Keybinds (exports a function to be used in ../../after/plugin/lsp.lua b/c we need a reference to the current buffer) --
M.map_lsp_keybinds = function(buffer_number)
	local opts = function(desc)
		return { buffer = buffer_number, desc = desc }
	end

	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded" })
	end, opts("Hover Documentation"))

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("LSP: [G]oto [D]efinition"))
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("LSP: [G]oto [D]eclaration"))
	vim.keymap.set("n", "gi", snacks.picker.lsp_implementations, opts("LSP: [G]oto [I]mplementation"))
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts("LSP: [T]ype [D]efinition"))
	vim.keymap.set("n", "gr", snacks.picker.lsp_references, opts("LSP: [G]oto [R]eferences"))
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("LSP: [R]e[n]ame"))
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("LSP: [C]ode [A]ction"))

	vim.keymap.set("n", "<leader>k", function()
		vim.lsp.buf.signature_help({ border = "rounded" })
	end, opts("LSP: Signature Documentation"))
end

vim.keymap.set("n", "<leader>ts", function()
	if twoslash.config.is_enabled then
		vim.cmd("TwoslashQueriesDisable")
		Snacks.notify.info("Two Slash queries disabled")
		return
	end

	vim.cmd(":TwoslashQueriesEnable")
	Snacks.notify.info("Two Slash queries enabled")
end, { desc = "Toggle [T]wo [S]lash queries" })

-- Symbol Outline keybind
vim.keymap.set("n", "<leader>so", ":SymbolsOutline<cr>")

-- nvim-ufo keybinds
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

-- toggle inlay hints
-- vim.keymap.set("n", "<leader>ih", function()
-- 	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
-- end)

-- Insert --
-- Map jj to <esc>
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("i", "JJ", "<esc>")

-- Visual --
-- Disable Space bar since it'll be used as the leader key
vim.keymap.set("v", "<space>", "<nop>")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
vim.keymap.set("v", "L", "$<left>")
vim.keymap.set("v", "H", "^")

-- Paste without losing the contents of the register
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", '"_dP')

-- Reselect the last visual selection
vim.keymap.set("x", "<<", function()
	-- Move selected text up/down in visual mode
	vim.cmd("normal! <<")
	vim.cmd("normal! gv")
end)

vim.keymap.set("x", ">>", function()
	vim.cmd("normal! >>")
	vim.cmd("normal! gv")
end)

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
