local add, gh, later = vim.pack.add, Config.gh, Config.later

later(function()
  add { gh "stevearc/oil.nvim" }

  local function parse_output(proc)
    local result = proc:wait()
    local entries = {}
    if result.code == 0 then
      for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
        entries[line:gsub("/$", "")] = true
      end
    end
    return entries
  end

  local function new_git_status()
    return setmetatable({}, {
      __index = function(self, dir)
        local ignored = vim.system(
          { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
          { cwd = dir, text = true }
        )
        local tracked = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, { cwd = dir, text = true })
        local status = {
          ignored = parse_output(ignored),
          tracked = parse_output(tracked),
        }
        rawset(self, dir, status)
        return status
      end,
    })
  end

  local git_status = new_git_status()
  local refresh = require("oil.actions").refresh
  local original_refresh = refresh.callback
  refresh.callback = function(...)
    git_status = new_git_status()
    original_refresh(...)
  end

  require("oil").setup {
    float = {
      max_width = 0.45,
      max_height = 0.5,
      border = "single",
    },
    confirmation = {
      border = "rounded",
      max_width = 80,
      min_width = 40,
    },
    keymaps = {
      ["<tab>"] = "actions.select",
      ["<s-tab>"] = "actions.parent",
      ["<Esc>"] = { "actions.close", mode = "n" },
      ["<C-j>"] = { "j", mode = "n" },
      ["<C-k>"] = { "k", mode = "n" },
      ["="] = { "actions.cd", mode = "n" },
      ["-"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["g'"] = { "actions.toggle_trash", mode = "n" },
    },
    view_options = {
      is_hidden_file = function(name, bufnr)
        local dir = require("oil").get_current_dir(bufnr)
        local is_dotfile = vim.startswith(name, ".") and name ~= ".."
        if not dir then
          return is_dotfile
        end
        if is_dotfile then
          return not git_status[dir].tracked[name]
        end
        return git_status[dir].ignored[name]
      end,
    },
    ssh = {
      border = "single",
    },
    keymaps_help = {
      border = "single",
    },
  }

  Config.new_autocmd("FileType", "oil", function()
    vim.opt_local.colorcolumn = ""
  end, "Hide color column in Oil")
end)
