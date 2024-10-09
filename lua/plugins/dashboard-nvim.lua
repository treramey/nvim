return {
	-- "nvimdev/dashboard-nvim",
	-- event = "VimEnter",
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	-- -- has history of breaking changes without notices
	-- pin = true,
	-- config = function()
	-- 	local db = require("dashboard")
	--
	-- 	db.setup({
	-- 		theme = "hyper",
	-- 		config = {
	-- 			header = {
	-- 				[[                                              ]],
	-- 				[[                                              ]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢾⣿⣿⣿⣿⢣⣷⢻⣿⣿⣿⣿⢿⣻⢯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⡽⣞⢿⣿⣿⣿⣳⢿⡺⣿⣿⣏⢯⣾⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⡷⢿⣮⡻⣿⣿⣹⣿⣧⡻⣿⡏⣮⡷⣧⢯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⡿⣿⢿⣿⣿⣿⣿⣿⣿⣷⢹⣫⣿⣿⣷⣿⣷⣽⣿⣿⣝⡇⢹⣟⣿⣞⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣦⡛⢮⡺⡻⣭⣭⣭⣭⣬⣥⡴⣯⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣭⢯⣛⡿⡿⣟⣛⢏⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣷⣭⣛⠵⢺⢯⣻⣷⢏⣾⢟⣿⣿⣿⣳⡿⣽⣿⣿⡏⣿⢿⣿⣿⢻⣿⣿⣾⡿⢟⣫⣾⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣛⠛⢛⣛⣛⣛⣛⣿⣭⣿⣽⢣⡿⣱⣿⣿⣿⢳⣟⣼⣿⣿⣿⣿⢻⡼⣿⣿⠞⣿⣿⣿⡜⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣷⣶⣮⡍⣍⡛⣣⡿⣴⠏⡾⢻⣿⣿⢯⣟⡞⣿⣿⢻⣿⣿⣏⡟⣿⣏⡿⣹⣿⣿⡿⣗⢝⢿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⡿⢟⣝⣴⢫⣿⡇⣿⣸⠇⡋⣿⠣⣼⣟⢘⣿⠏⢺⡿⢸⣿⢹⣿⣯⣷⢹⣎⢿⣧⠻⣎⢓⣬⣽⣾⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⡿⠛⢥⣚⣋⠭⢠⢳⡏⣗⢧⠳⡄⡗⡏⣼⢏⢢⠾⢣⡆⣿⠳⣹⢳⣿⣿⣿⣿⡏⣿⡜⡟⣡⡙⠮⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⢻⡽⠤⣺⠏⡜⡿⡲⣸⡇⠇⢣⡫⣲⢌⣳⣿⢸⢧⡃⣽⣸⢱⢻⡟⣼⡇⠿⢧⠱⣱⠻⣾⣔⣻⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⡿⢈⡜⣁⠞⡘⠕⣰⢟⡃⠙⠦⣴⢏⢠⣻⡜⡎⣲⣇⡇⢧⢎⡿⡰⣑⡵⣝⡁⠙⡆⡛⣮⣽⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣷⣾⣯⡜⢊⠰⣳⠆⢟⠻⠏⢖⣾⣯⠎⣿⡯⠧⠜⠿⢧⠏⡎⡽⠕⣱⣿⠎⢦⡷⡅⣔⠸⣾⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣭⣾⡧⢉⣾⠚⠛⠘⣬⣿⣿⠖⠿⢵⢿⣧⣳⠦⡼⢇⡴⣡⣿⣿⣸⡵⠇⣼⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣾⣯⠀⠋⠀⢘⣛⡃⠘⠋⠀⠱⠾⠖⢋⣼⣟⣰⣿⡟⣾⠿⠁⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢀⠀⡜⡻⣷⣄⠀⠀⠀⣥⣼⣿⣿⣿⣿⣿⠃⢀⣺⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣌⢻⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⣨⣿⡿⠀⠚⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡹⣭⣽⣛⡻⢿⣿⣿⣿⡿⢛⢤⣾⣿⣿⠿⠇⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡜⢿⣿⣿⣾⠟⠏⡅⡞⡵⠛⠋⠁⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣈⠉⠉⠀⡦⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠁⠂⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- 				[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠿⣿⣿⣿⣿⣿⣿]],
	-- 				[[                                              ]],
	-- 				[[                                              ]],
	-- 			},
	-- 			shortcut = {
	-- 				{
	-- 					desc = "󱖫 Plugins status",
	-- 					group = "@event",
	-- 					action = "Lazy check",
	-- 					key = "a",
	-- 				},
	-- 				-- {
	-- 				-- 	desc = " Todos",
	-- 				-- 	group = "DiagnosticHint",
	-- 				-- 	action = "TodoTelescope",
	-- 				-- 	key = "b",
	-- 				-- },
	-- 				{
	-- 					desc = "  File Browser",
	-- 					group = "Number",
	-- 					action = "Telescope find_files",
	-- 					key = "c",
	-- 				},
	-- 				{
	-- 					desc = "  Recent files",
	-- 					group = "@repeat",
	-- 					action = "Telescope oldfiles",
	-- 					key = "d",
	-- 				},
	-- 			},
	-- 			mru = {
	-- 				enable = false,
	-- 				limit = 3,
	-- 			},
	-- 			project = {
	-- 				enable = false,
	-- 				limit = 8,
	-- 				icon = "your icon",
	-- 				label = "",
	-- 				action = "Telescope find_files cwd=",
	-- 			},
	-- 			footer = {},
	-- 		},
	-- 	})
	-- end,
}