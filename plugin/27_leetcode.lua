local add, gh, now = vim.pack.add, Config.gh, Config.now

local leet_arg = "lc"

if vim.fn.argv(0) ~= leet_arg then
  return
end

local function setup_mini_pick()
  if vim.api.nvim_get_commands({}).Pick then
    return
  end

  require("mini.pick").setup {
    window = {
      config = function()
        local height = math.floor(0.3 * vim.o.lines)
        local width = math.floor(0.45 * vim.o.columns)
        return {
          anchor = "NW",
          height = height,
          width = width,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
        }
      end,
    },
  }
end

local function setup_leetcode_keymaps()
  local keymap_opts = { noremap = true, silent = true }
  local maps = {
    { "m", "menu", "Leetcode Menu" },
    { "q", "exit", "Leetcode Exit" },
    { "c", "console", "Leetcode Console" },
    { "i", "info", "Leetcode Info" },
    { "t", "tabs", "Leetcode Tabs" },
    { "y", "yank", "Leetcode Yank" },
    { "l", "lang", "Leetcode Change Language" },
    { "r", "run", "Leetcode Run" },
    { "s", "submit", "Leetcode Submit" },
    { "R", "random", "Leetcode Random" },
    { "d", "daily", "Leetcode Daily" },
    { "L", "list", "Leetcode List" },
    { "o", "open", "Leetcode Open in Browser" },
    { "e", "reset", "Leetcode Reset" },
    { "a", "last_submit", "Leetcode Last Submit" },
    { "v", "restore", "Leetcode Restore Layout" },
  }

  for _, map in ipairs(maps) do
    vim.keymap.set(
      "n",
      "<leader>l" .. map[1],
      "<cmd>Leet " .. map[2] .. "<cr>",
      vim.tbl_extend("force", keymap_opts, { desc = map[3] })
    )
  end
end

local function setup_leader_group()
  for _, clue in ipairs(Config.leader_group_clues or {}) do
    if clue.mode == "n" and clue.keys == "<Leader>l" then
      clue.desc = "+leetcode"
      return
    end
  end
end

now(function()
  add {
    gh "nvim-lua/plenary.nvim",
    gh "MunifTanjim/nui.nvim",
    gh "kawre/leetcode.nvim",
  }

  setup_mini_pick()

  require("leetcode").setup {
    arg = leet_arg,
    lang = "python",
    picker = { provider = "mini-picker" },
    image_support = true,
  }

  -- Hide tab bar to avoid ugly buffer names.
  vim.o.showtabline = 0

  setup_leader_group()
  setup_leetcode_keymaps()
end)
