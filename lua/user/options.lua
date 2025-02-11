-- Enable relative line numbers
vim.opt.nu = true
vim.opt.rnu = true

-- Disable showing the mode below the statusline
vim.opt.showmode = false

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

-- Disable text wrap
vim.opt.wrap = false

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease updatetime to 250ms
vim.opt.updatetime = 250

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- Enable persistent undo history
vim.opt.undofile = true

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"

-- Enable access to System Clipboard
vim.opt.clipboard = "unnamedplus"

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Set fold settings
-- These options were reccommended by nvim-ufo
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = "0"
vim.opt.foldnestmax = 5
vim.opt.foldtext = ""

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Place a column line
vim.opt.colorcolumn = "120"

vim.opt.guicursor = {
	"n-v-c:block", -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
	"r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
	"o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
	"a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
	"sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
}

-- This forces the use of OSC 52 which allows Neovim to 'forward' copy and paste
-- commands via the terminal.
--
-- What this means is, whether you're in Neovim on a remote server,
-- copy and paste commands will be driven thru your terminal emulator
-- and thus, into your host system's clipboard.
-- -- TMUX documentation about its clipboard - https://github.com/tmux/tmux/wiki/Clipboard#the-clipboard

local is_tmux_session = vim.env.TERM_PROGRAM == "tmux" -- Tmux is its own clipboard provider which directly works.
if vim.env.SSH_TTY then
	local osc52 = require("vim.ui.clipboard.osc52")
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = osc52.copy("+"),
			["*"] = osc52.copy("*"),
		},
		paste = {
			["+"] = osc52.paste("+"),
			["*"] = osc52.paste("*"),
		},
	}
end

-- If we  are running inside ssh AND we are in a tmux sesssion, OSC 52 won't
-- work, instead we can use tmux's native copy/paste functionality.
if vim.env.SSH_TTY and is_tmux_session then
	local copy = { "tmux", "load-buffer", "-w", "-" }
	local paste = { "bash", "-c", "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -" }
	vim.g.clipboard = {
		name = "tmux",
		copy = {
			["+"] = copy,
			["*"] = copy,
		},
		paste = {
			["+"] = paste,
			["*"] = paste,
		},
		cache_enabled = 0,
	}
end

-- Creating a new comment string after 'o' is annoying, enforce it never happens
-- but ensure it does happen on new lines (r option).
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set formatoptions-=o",
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set formatoptions+=r",
})
