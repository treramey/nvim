local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap
local inoremap = require("user.keymap_utils").inoremap
local tnoremap = require("user.keymap_utils").tnoremap
local xnoremap = require("user.keymap_utils").xnoremap
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")
local conform = require("conform")
local smart_splits = require("smart-splits")

local M = {}

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- Window +  better navigation
nnoremap("<C-h>", function()
	smart_splits.move_cursor_left()
end)

nnoremap("<C-j>", function()
	smart_splits.move_cursor_down()
end)

nnoremap("<C-k>", function()
	smart_splits.move_cursor_up()
end)

nnoremap("<C-l>", function()
	smart_splits.move_cursor_right()
end)

-- Select all and yank with Ctrl-a
nnoremap("<C-a>", "ggVGy", { desc = "Select all and yank" })

-- Swap between last two buffers
nnoremap("<leader>'", "<C-^>", { desc = "Switch to last buffer" })

-- Save with leader key
nnoremap("<leader>w", "<cmd>w<cr>", { silent = false })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q<cr>", { silent = false })

-- Map Oil to <leader>e
nnoremap("<leader>e", function()
	require("oil").toggle_float()
end)

-- Map Undotree to <leader>
nnoremap("<leader>ut", ":UndotreeToggle<CR>", { desc = "Toggle [U]ndo[T]ree " })

-- Center buffer while navigating
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("{", "{zz")
nnoremap("}", "}zz")
nnoremap("N", "Nzz")
nnoremap("n", "nzz")
nnoremap("G", "Gzz")
nnoremap("gg", "ggzz")
nnoremap("gd", "gdzz")
nnoremap("<C-i>", "<C-i>zz")
nnoremap("<C-o>", "<C-o>zz")
nnoremap("%", "%zz")
nnoremap("*", "*zz")
nnoremap("#", "#zz")

-- Press 'S' for quick find/replace for the word under the cursor
nnoremap("S", function()
	local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end)

-- Open Spectre for global find/replace
nnoremap("<leader>S", function()
	require("spectre").toggle()
end)

-- Open Spectre for global find/replace for the word under the cursor in normal mode
-- TODO Fix, currently being overriden by Telescope
nnoremap("<leader>sw", function()
	require("spectre").open_visual({ select_word = true })
end, { desc = "Search current word" })

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
nnoremap("L", "$")
nnoremap("H", "^")

-- Press 'U' for redo
nnoremap("U", "<C-r>")

-- Turn off highlighted results
nnoremap("<leader>no", "<cmd>noh<cr>")

nnoremap("<leader>tw", function()
	Snacks.toggle.option("wrap")
end, { desc = "[T]oggle [Wrap]" })

-- Diagnostics
-- Goto next diagnostic of any severity
nnoremap("]d", function()
	vim.diagnostic.goto_next({})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
nnoremap("[d", function()
	vim.diagnostic.goto_prev({})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next warning diagnostic
nnoremap("]w", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous warning diagnostic
nnoremap("[w", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Open the diagnostic under the cursor in a float window
nnoremap("<leader>d", function()
	vim.diagnostic.open_float({
		border = "rounded",
	})
end)

-- Navigate to next qflist item
nnoremap("<leader>cn", ":cnext<cr>zz")

-- Navigate to previos qflist item
nnoremap("<leader>cp", ":cprevious<cr>zz")

-- Open the qflist
nnoremap("<leader>co", ":copen<cr>zz")

-- Close the qflist
nnoremap("<leader>cc", ":cclose<cr>zz")

-- Map MaximizerToggle (szw/vim-maximizer) to leader-m
nnoremap("<leader>m", ":MaximizerToggle<cr>")

-- Resize split windows to be equal size
nnoremap("<leader>=", "<C-w>=")

-- Press leader f to format
nnoremap("<leader>f", function()
	conform.format({
		async = true,
		timeout_ms = 500,
		lsp_format = "fallback",
	})
end, { desc = "Format the current buffer" })

-- Press leader rw to rotate open windows
nnoremap("<leader>rw", ":RotateWindows<cr>", { desc = "[R]otate [W]indows" })

-- Press gx to open the link under the cursor
nnoremap("gx", ":sil !open <cWORD><cr>", { silent = true })

-- TSC autocommand keybind to run TypeScripts tsc
nnoremap("<leader>tc", ":TSC<cr>", { desc = "[T]ypeScript [C]ompile" })

-- Harpoon keybinds --
-- Open harpoon ui
nnoremap("<leader>ho", function()
	harpoon_ui.toggle_quick_menu()
end)

-- Add current file to harpoon
nnoremap("<leader>ha", function()
	harpoon_mark.add_file()
end)

-- Remove current file from harpoon
nnoremap("<leader>hr", function()
	harpoon_mark.rm_file()
end)

-- Remove all files from harpoon
nnoremap("<leader>hc", function()
	harpoon_mark.clear_all()
end)

-- Quickly jump to harpooned files
nnoremap("<leader>1", function()
	harpoon_ui.nav_file(1)
end)

nnoremap("<leader>2", function()
	harpoon_ui.nav_file(2)
end)

nnoremap("<leader>3", function()
	harpoon_ui.nav_file(3)
end)

nnoremap("<leader>4", function()
	harpoon_ui.nav_file(4)
end)

nnoremap("<leader>5", function()
	harpoon_ui.nav_file(5)
end)

-- Telescope keybinds --
nnoremap("<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
nnoremap("<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch Open [B]uffers" })
nnoremap("<leader>sf", function()
	require("telescope.builtin").find_files({ hidden = true })
end, { desc = "[S]earch [F]iles" })
nnoremap("<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
nnoremap("<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
nnoremap("<leader>st", ":TodoTelescope<CR>", { desc = "[S]earch TODOs" })

nnoremap("<leader>sc", function()
	require("telescope.builtin").commands(require("telescope.themes").get_dropdown({
		previewer = false,
	}))
end, { desc = "[S]earch [C]ommands" })

nnoremap("<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

nnoremap("<leader>ss", function()
	require("telescope.builtin").spell_suggest(require("telescope.themes").get_dropdown({
		previewer = false,
	}))
end, { desc = "[S]earch [S]pelling suggestions" })

nnoremap("<leader>fl", ":TodoQuickFix<CR>", { desc = "[F]ind [L]ines with TODOs" })

-- LSP Keybinds (exports a function to be used in ../../after/plugin/lsp.lua b/c we need a reference to the current buffer) --
M.map_lsp_keybinds = function(buffer_number)
	local opts = function(desc)
		return { buffer = buffer_number, desc = desc }
	end

	nnoremap("K", vim.lsp.buf.hover, opts("Hover Documentation"))
	nnoremap("gd", vim.lsp.buf.definition, opts("LSP: [G]oto [D]efinition"))
	nnoremap("gD", vim.lsp.buf.declaration, opts("LSP: [G]oto [D]eclaration"))
	nnoremap("gi", vim.lsp.buf.implementation, opts("LSP: [G]oto [I]mplementation"))
	nnoremap("gt", vim.lsp.buf.type_definition, opts("LSP: [T]ype [D]efinition"))
	nnoremap("gr", require("telescope.builtin").lsp_references, opts("LSP: [G]oto [R]eferences"))
	nnoremap("<leader>rn", vim.lsp.buf.rename, opts("LSP: [R]e[n]ame"))
	nnoremap("<leader>ca", vim.lsp.buf.code_action, opts("LSP: [C]ode [A]ction"))
	nnoremap("<leader>k", vim.lsp.buf.signature_help, opts("LSP: Signature Documentation"))
	nnoremap("<leader>bs", require("telescope.builtin").lsp_document_symbols, opts("LSP: [B]uffer [S]ymbols"))
end

-- Symbol Outline keybind
nnoremap("<leader>so", ":SymbolsOutline<cr>")

-- Open Copilot panel
nnoremap("<leader>oc", function()
	require("copilot.panel").open({})
end, { desc = "[O]pen [C]opilot panel" })

-- nvim-ufo keybinds
nnoremap("zR", require("ufo").openAllFolds)
nnoremap("zM", require("ufo").closeAllFolds)

-- toggle inlay hints
nnoremap("<leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end)

-- Insert --
-- Map jj to <esc>
inoremap("jj", "<esc>")
inoremap("JJ", "<esc>")

-- Visual --
-- Disable Space bar since it'll be used as the leader key
vnoremap("<space>", "<nop>")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
vnoremap("L", "$<left>")
vnoremap("H", "^")

-- Paste without losing the contents of the register
vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
vnoremap("<A-k>", ":m '<-2<CR>gv=gv")

xnoremap("<leader>p", '"_dP')

-- Reselect the last visual selection
xnoremap("<<", function()
	-- Move selected text up/down in visual mode
	vim.cmd("normal! <<")
	vim.cmd("normal! gv")
end)

xnoremap(">>", function()
	vim.cmd("normal! >>")
	vim.cmd("normal! gv")
end)

-- Terminal --
-- Enter normal mode while in a terminal
tnoremap("<esc><esc>", [[<C-\><C-n>]])

-- Window navigation from terminal
tnoremap("<C-h>", [[<Cmd>wincmd h<CR>]])
tnoremap("<C-j>", [[<Cmd>wincmd j<CR>]])
tnoremap("<C-k>", [[<Cmd>wincmd k<CR>]])
tnoremap("<C-l>", [[<Cmd>wincmd l<CR>]])

-- Reenable default <space> functionality to prevent input delay
tnoremap("<space>", "<space>")

return M
