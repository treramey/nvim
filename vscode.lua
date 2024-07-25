local map = require("user.keymap_utils").map
local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap
local inoremap = require("user.keymap_utils").inoremap
local tnoremap = require("user.keymap_utils").tnoremap
local xnoremap = require("user.keymap_utils").xnoremap

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable access to System Clipboard
vim.opt.clipboard = "unnamed,unnamedplus"

-- Set tabs to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Enable auto indenting and set it to spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 2

-- Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
vim.opt.breakindent = true

-- Enable incremental searching
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease updatetime to 250ms
vim.opt.updatetime = 250

-- Enable relative line numbers
vim.opt.nu = true
vim.opt.rnu = true

-- Disable text wrap
vim.opt.wrap = false

-- Better splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- better window navigation
nnoremap("<C-h>", "<Cmd>call VSCodeCall('workbench.action.navigateLeft')<CR>")
nnoremap("<C-j>", "<Cmd>call VSCodeCall('workbench.action.navigateDown')<CR>")
nnoremap("<C-k>", "<Cmd>call VSCodeCall('workbench.action.navigateUp')<CR>")
nnoremap("<C-l>", "<Cmd>call VSCodeCall('workbench.action.navigateRight')<CR>")

nnoremap("<leader>e", "<cmd>call VSCodeCall('workbench.action.toggleSidebarVisibility')<CR>")
nnoremap("<leader>q", "<cmd>call VSCodeCall('workbench.action.closeActiveEditor')<CR>")
nnoremap("<leader>w", "<cmd>call VSCodeCall('workbench.action.files.save')<CR>")
nnoremap("<leader>f", "<cmd>call VSCodeCall('editor.action.formatDocument')<CR>")

-- lets add some fancy search
map("<leader>sf", "<cmd>call VSCodeCall('find-it-faster.findFiles')<CR>")
map("<leader>sg", "<cmd>call VSCodeCall('find-it-faster.findWithinFiles')<CR>")
map("<leader>ss", "<cmd>call VSCodeCall('searchEverywhere.search')<CR>")

-- Map jj to <esc>
-- is in settings.json

-- Lsp mappings
nnoremap("rn", "<cmd>call VSCodeCall('editor.action.rename')<CR>")
nnoremap("ca", "<cmd>call VSCodeCall('editor.action.quickFix')<CR>")
nnoremap("gr", "<cmd>call VSCodeCall('editor.action.goToReferences')<CR>")
nnoremap("gi", "<cmd>call VSCodeCall('editor.action.goToImplementation')<CR>")

-- DEBUGGING
nnoremap("<leader>dd", "<cmd>call VSCodeCall('workbench.action.debug.start')<CR>")
nnoremap("<leader>ds", "<cmd>call VSCodeCall('workbench.action.debug.stop')<CR>")
nnoremap("<leader>dc", "<cmd>call VSCodeCall('workbench.action.debug.continue')<CR>")
nnoremap("<leader>dp", "<cmd>call VSCodeCall('workbench.action.debug.pause')<CR>")
nnoremap("<leader>dr", "<cmd>call VSCodeCall('workbench.action.debug.run')<CR>")
nnoremap("<leader>dR", "<cmd>call VSCodeCall('workbench.action.debug.restart')<CR>")
nnoremap("<leader>di", "<cmd>call VSCodeCall('workbench.action.debug.stepInto')<CR>")
nnoremap("<leader>ds", "<cmd>call VSCodeCall('workbench.action.debug.stepOver')<CR>")
nnoremap("<leader>do", "<cmd>call VSCodeCall('workbench.action.debug.stepOut')<CR>")
nnoremap("<leader>db", "<cmd>call VSCodeCall('editor.debug.action.toggleBreakpoint')<CR>")
nnoremap("<leader>dB", "<cmd>call VSCodeCall('editor.debug.action.toggleInlineBreakpoint')<CR>")
nnoremap("<leader>dj", "<cmd>call VSCodeCall('debug.jumpToCursor')<CR>")
nnoremap("<leader>dv", "<cmd>call VSCodeCall('workbench.debug.action.toggleRepl')<CR>")
nnoremap("<leader>dw", "<cmd>call VSCodeCall('workbench.debug.action.focusWatchView')<CR>")
nnoremap("<leader>dW", "<cmd>call VSCodeCall('editor.debug.action.selectionToWatch')<CR>")

-- Visual --
-- Disable Space bar since it'll be used as the leader key
vnoremap("<space>", "<nop>")

-- -- Press 'H', 'L' to jump to start/end of a line (first/last char)
map("L", "$")
map("H", "^")

nnoremap("<up>", "<nop>")
nnoremap("<down>", "<nop>")
inoremap("<up>", "<nop>")
inoremap("<down>", "<nop>")
inoremap("<left>", "<nop>")
inoremap("<right>", "<nop>")

-- paste without overwriting
vim.keymap.set("v", "p", "P")

vim.keymap.set("n", "<left>", "<Cmd>bp<CR>")
vim.keymap.set("n", "<right>", "<Cmd>bn<CR>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("", "<Leader>cs", "<Cmd>nohlsearch<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "Highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})
