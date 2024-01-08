-- Detect and set the proper file type for ReasonML files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.inc,*.cfc,*.cfm",
  desc = "Detect and set the proper file type for CFML files",
  callback = function()
    vim.cmd("set filetype=cfml")
  end,
})
