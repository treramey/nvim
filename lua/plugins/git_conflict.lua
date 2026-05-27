return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufRead",
  opts = {
    disable_diagnostics = false,
  },
  init = function()
    local group = vim.api.nvim_create_augroup("GitConflictDiagnostics", { clear = true })
    local autoformat_disabled_by_conflict = "git-conflict"
    local restore_autoformat_var = "git_conflict_autoformat_restore"

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "GitConflictDetected",
      callback = function(args)
        vim.diagnostic.enable(false, { bufnr = args.buf })

        if vim.b[args.buf][restore_autoformat_var] == nil then
          vim.b[args.buf][restore_autoformat_var] = {
            had_value = vim.b[args.buf].disable_autoformat ~= nil,
            value = vim.b[args.buf].disable_autoformat,
          }
        end

        vim.b[args.buf].disable_autoformat = autoformat_disabled_by_conflict
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "GitConflictResolved",
      callback = function(args)
        vim.diagnostic.enable(true, { bufnr = args.buf })

        local restore = vim.b[args.buf][restore_autoformat_var]
        if restore and vim.b[args.buf].disable_autoformat == autoformat_disabled_by_conflict then
          if restore.had_value then
            vim.b[args.buf].disable_autoformat = restore.value
          else
            vim.b[args.buf].disable_autoformat = nil
          end
        end

        vim.b[args.buf][restore_autoformat_var] = nil
      end,
    })
  end,
  keys = {
    {
      "<leader>gd",
      function()
        require("treramey.merge_diff").open()
      end,
      desc = "3-way merge diff",
    },
    { "<leader>gx", "<cmd>GitConflictListQf<cr>", desc = "conflicts to quickfix" },
  },
}
