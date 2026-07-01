local add, gh, later = vim.pack.add, Config.gh, Config.later

local dotnet = require "treramey.dotnet"

if vim.fn.executable "dotnet" == 1 then
  dotnet.setup_env()
end

local function setup_dotnet_keymaps()
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = desc })
  end

  -- stylua: ignore start
  map("<leader>nw", "<cmd>Dotnet watch<cr>", "watch solution")
  map("<leader>nb", "<cmd>Dotnet build quickfix<cr>", "build quickfix")
  map("<leader>nB", "<cmd>Dotnet build<cr>", "build")
  map("<leader>nr", "<cmd>Dotnet restore<cr>", "restore packages")
  map("<leader>nQ", "<cmd>Dotnet build solution quickfix<cr>", "build solution quickfix")
  map("<leader>nR", "<cmd>Dotnet run solution<cr>", "run solution")
  map("<leader>nx", "<cmd>Dotnet clean<cr>", "clean solution")
  map("<leader>nn", "<cmd>Dotnet<cr>", "open dotnet menu")
  map("<leader>na", "<cmd>Dotnet new<cr>", "new item")
  map("<leader>nt", "<cmd>Dotnet testrunner<cr>", "open test runner")
  map("<leader>np", "<cmd>DotnetListPackages<cr>", "list packages")
  map("<leader>ns", "<cmd>DotnetLaunchSettings<cr>", "open launchSettings.json")
  -- stylua: ignore end
end

local function setup_leader_group()
  for _, clue in ipairs(Config.leader_group_clues or {}) do
    if clue.mode == "n" and clue.keys == "<Leader>n" then
      clue.desc = "+dotnet/notify"
      return
    end
  end
end

local function setup_mini_files_integration()
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      vim.keymap.set("n", "<leader>a", function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then
          vim.notify("[easy-dotnet] Cursor is not on a valid MiniFiles entry", vim.log.levels.WARN)
          return
        end

        local default = vim.fn.fnamemodify(path, ":.") .. "/"
        vim.ui.input({ prompt = "Create file ", default = default }, function(input)
          if input == nil or input == "" then
            return
          end

          require("easy-dotnet").create_item(input, function()
            MiniFiles.synchronize()
          end)
        end)
      end, { buffer = args.data.buf_id, desc = "Create file from dotnet template" })
    end,
  })
end

if vim.fn.executable "dotnet" == 1 then
  setup_leader_group()
end

later(function()
  if vim.fn.executable "dotnet" ~= 1 then
    return
  end

  add {
    gh "nvim-lua/plenary.nvim",
    gh "mfussenegger/nvim-dap",
    gh "GustavEikaas/easy-dotnet.nvim",
  }

  dotnet.setup_easy_dotnet()
  setup_dotnet_keymaps()
  setup_mini_files_integration()
end)
