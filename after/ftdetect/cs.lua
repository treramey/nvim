-- Setup syntax highlighting
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.props" },

  callback = function()
    vim.cmd("setlocal syntax=xml")
    vim.cmd("setlocal filetype=xml")
  end,
})

vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
})
