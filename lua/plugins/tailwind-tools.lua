return {
	"luckasRanarison/tailwind-tools.nvim",
	ft = { "html", "typescriptreact", "javascriptreact", "svelte" },
	build = ":UpdateRemotePlugins",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"neovim/nvim-lspconfig",
	},
	-- opts = {
	-- 	document_color = {
	-- 		enabled = true,
	-- 		kind = "inline",
	-- 		inline_symbol = "󰝤 ",
	-- 		debounce = 200,
	-- 	},
	-- 	conceal = {
	-- 		enabled = false,
	-- 		symbol = "󱏿",
	-- 		highlight = {
	-- 			fg = "#38BDF8",
	-- 		},
	-- 	},
	-- },
	-- config = function(_, opts)
	-- 	require("tailwind-tools").setup(opts)
	-- end,
}
