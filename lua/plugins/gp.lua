return {
	"robitx/gp.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>pn", "<Cmd>GpChatNew split<CR>", desc = "New Chat" },
		{ "<leader>pn", ":<C-u>'<,'>GpChatNew split<CR>", mode = { "x" }, desc = "New Chat" },
		{ "<leader>pt", "<Cmd>GpChatToggle split<CR>", desc = "Toggle Chat" },
		{ "<leader>pt", ":<C-u>'<,'>GpChatToggle split<CR>", mode = { "x" }, desc = "Toggle Chat" },
		{ "<leader>pf", "<Cmd>GpChatFinder<CR>", desc = "Find Chat" },
		{ "<leader>pp", ":<C-u>'<,'>GpChatPaste<CR>", mode = { "x" }, desc = "Chat Paste" },
		{ "<leader>pr", "<Cmd>GpChatRespond<CR>", desc = "Chat Respond" },
		{ "<leader>pd", "<Cmd>GpChatDelete<CR>", desc = "Chat Delete" },
		{ "<leader>ps", "<Cmd>GpChatStop<CR>", desc = "Chat Stop" },
	},
	config = function()
		require("gp").setup({
			openai_api_key = os.getenv("OPENAI_API_KEY"),
			chat_topic_gen_model = "gpt-4-turbo-preview",
		})
	end,
}
