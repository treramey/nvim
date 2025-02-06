local Path = require("plenary.path")

vim.api.nvim_create_user_command("CopyFilePathToClipboard", function()
	-- Get the current buffer's file path
	local file_path = vim.api.nvim_buf_get_name(0)

	-- Create a Path object for the current directory and get the parent directory
	local project_root_parent_dir = Path:new(vim.fn.getcwd()):parent():absolute()

	-- Create a Path object for the file
	local path_obj = Path:new(file_path)

	-- Get the relative path from the project root
	local relative_path = path_obj:make_relative(project_root_parent_dir)

	-- Copy the relative path to the system clipboard
	vim.fn.setreg("+", relative_path)
end, {})

vim.api.nvim_create_user_command("CFP", function()
	vim.cmd(":CopyFilePathToClipboard")
end, {})

--  https://www.reddit.com/r/neovim/comments/1d6wreh/comment/logifn9/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
--  clipboard overrides is needed as Alacritty does not support runtime OSC 52 detection.
--  In SSH_TTY, OSC 52 should work, but needs to be overridden as I use Alacritty.
--  In local (not SSH session), LazyVim default clipboard providers can be used.
--   Sample references -
--   https://github.com/folke/which-key.nvim/issues/584 - Has references to when clipboard is modified
--   Some more info here - https://www.reddit.com/r/neovim/comments/17rbbec/neovim_nightly_now_you_can_copy_via_ssh_with/
--
--
--  You can test OSC 52 in terminal by using following in your terminal -
--  printf $'\e]52;c;%s\a' "$(base64 <<<'hello world')"
-- local is_tmux_session = vim.env.TERM_PROGRAM == "tmux" -- Tmux is its own clipboard provider which directly works.
-- -- TMUX documentation about its clipboard - https://github.com/tmux/tmux/wiki/Clipboard#the-clipboard
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
if vim.env.TMUX ~= nil then
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
