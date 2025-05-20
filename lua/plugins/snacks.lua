local filtered_message = { "No information available" }

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		dependencies = {
			{
				"lewis6991/gitsigns.nvim",
				init = function()
					require("gitsigns").setup()
				end,
			},
		},
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			dim = { enabled = true },
			gitbrowse = { enabled = true },
			image = {
				doc = {
					inline = false,
					max_height = 12,
					max_width = 24,
				},
			},
			indent = {
				enabled = true,
				filter = function(buf)
					local b = vim.b[buf]
					local bo = vim.bo[buf]
					local excluded_filetypes = {
						markdown = true,
						text = true,
					}
					return vim.g.snacks_indent ~= false
						and b.snacks_indent ~= false
						and bo.buftype == ""
						and not excluded_filetypes[bo.filetype]
				end,
			},
			input = {
				enabled = true,
				win = {
					style = "input",
					relative = "editor",
					height = 1,
					width = 60,
					row = math.floor(((vim.o.lines - 1) * 0.33)), -- 1/3 down
					col = math.floor((vim.o.columns - 60) * 0.5), -- center
				},
			},
			lazygit = {
				configure = false,
				theme_path = vim.fs.normalize(vim.fn.expand("~/.config/lazygit/config.yml")),
			},
			notifier = {
				enabled = true,
				timeout = 3000,
				style = "fancy",
			},
			picker = {
				enabled = true,
				matchers = {
					frecency = true,
					cwd_bonus = false,
				},
				formatters = {
					file = {
						filename_first = false,
						filename_only = false,
						icon_width = 2,
					},
				},
				layout = {
					-- presets options : "default" , "ivy" , "ivy-split" , "telescope" , "vscode", "select" , "sidebar"
					-- override picker layout in keymaps function as a param below
					preset = "telescope", -- defaults to this layout unless overidden
					cycle = false,
				},
				hl = {
					border = "SnacksPickerBoxBorder",
					title = "SnacksPickerTitle",
					input_border = "SnacksPickerInputBorder",
				},
				layouts = {
					select = {
						preview = false,
						layout = {
							backdrop = false,
							width = 0.6,
							min_width = 80,
							height = 0.4,
							min_height = 10,
							box = "vertical",
							border = "rounded",
							title = "{title}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", width = 0.6, height = 0.4, border = "top" },
						},
					},
					telescope = {
						reverse = true, -- set to false for search bar to be on top
						layout = {
							box = "horizontal",
							backdrop = false,
							width = 0.8,
							height = 0.9,
							border = "none",
							{
								box = "vertical",
								{ win = "list", title = " Results ", title_pos = "center", border = "rounded" },
								{
									win = "input",
									height = 1,
									border = "rounded",
									title = "{title} {live} {flags}",
									title_pos = "center",
								},
							},
							{
								win = "preview",
								title = "{preview:Preview}",
								width = 0.50,
								border = "rounded",
								title_pos = "center",
							},
						},
					},
					ivy = {
						layout = {
							box = "vertical",
							backdrop = false,
							width = 0,
							height = 0.4,
							position = "bottom",
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "left",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list", border = "none" },
								{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
							},
						},
					},
				},
			},
			statuscolumn = {},
			terminal = {},
			toggle = { enabled = true },
			words = { enabled = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					local notify = Snacks.notifier.notify
					---@diagnostic disable-next-line: duplicate-set-field
					Snacks.notifier.notify = function(message, level, opts)
						for _, msg in ipairs(filtered_message) do
							if message == msg then
								return nil
							end
						end
						return notify(message, level, opts)
					end
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})
		end,
    -- stylua: ignore start
		keys = {
        -- LSP
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

			{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
			{ "<leader>B", function() Snacks.scratch.select() end, desc = "Select Scratch [B]uffer" },
      { "<leader>sf", function() Snacks.picker.files() end, desc = "find files" },
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "[B]uffer [D]elete" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "live grep" },
			{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame Line" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
			{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
			{ "<leader>og", function() Snacks.gitbrowse() end, desc = "[O]pen [G]it", mode = { "n", "v" } },
			{ "<leader>dn", function() Snacks.notifier.hide() end, desc = "[D]ismiss All [N]otifications" },
			{ "<leader>nh", function() Snacks.notifier.show_history() end, desc = "[N]otification [H]istory" },
			{ "<leader>zz", function() Snacks.toggle.dim():toggle() end, desc = "Toggle [Z]en Mode" },
			{ "<leader>cl", function() Snacks.toggle.option("cursorline", { name = "Cursor Line" }):toggle() end, desc = "Toggle [C]ursor [L]ine" },
			{ "<leader>td", function() Snacks.toggle.diagnostics():toggle() end, desc = "[T]oggle [D]iagnostics" },
      { "<leader>dm", function() Snacks.toggle.dim():toggle() end, desc = "Toggle [D]im [M]ode" }, -- Same as <leader>zz but with different key
			{ "<leader>zm", function() Snacks.toggle.zen():toggle() end, desc = "Toggle [Z]en [M]ode" },
      { "<leader>_", function() Snacks.terminal() end, desc = "terminal" },
      { "<leader>ln", function() Snacks.toggle.option("relativenumber", { name = "Relative Number" }):toggle() end, desc = "Toggle Relative [L]ine [N]umbers" },
      { "<leader>tw", function() Snacks.toggle.option("wrap"):toggle() end, desc = "[T]oggle line [W]rap" },
      -- stylua: ignore end

			{
				"<leader>tt",
				function()
					local tsc = require("treesitter-context")
					Snacks.toggle({
						name = "Treesitter Context",
						get = function() return tsc.enabled() end,
						set = function(state)
							if state then
								tsc.enable()
							else
								tsc.disable()
							end
						end,
					}):toggle()
				end,
				desc = "[T]oggle [T]reesitter Context",
			},
			{
				"<leader>hl",
				function()
					local hc = require("nvim-highlight-colors")
					Snacks.toggle({
						name = "Highlight Colors",
						get = function()
							return hc.is_active()
						end,
						set = function(state)
							if state then
								hc.turnOn()
							else
								hc.turnOff()
							end
						end,
					}):toggle()
				end,
				desc = "Toggle [H]igh[L]ight Colors",
			},
      {
      "<leader>ih",
      function()
        Snacks.toggle({
          name = "Inlay Hints",
          get = function()
            return vim.lsp.inlay_hint.is_enabled()
          end,
          set = function(state)
            if state then
              vim.lsp.inlay_hint.enable(true)
            else
              vim.lsp.inlay_hint.enable(false)
            end
          end,
        }):toggle()
      end,
      desc = "Toggle [I]nlay [H]ints",
      },
		},
	},
}
