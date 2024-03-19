return {
	{
		"dmmulroy/ts-error-translator.nvim",
		enable = true,
		config = function()
			require("ts-error-translator").setup()
		end,
	},
}
