vim.api.nvim_create_user_command("ConformDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable conform-autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("ConformEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable conform-autoformat-on-save",
})

vim.api.nvim_create_user_command("SetColumnWidth80", function()
  vim.opt.colorcolumn = "80"
end, {})

vim.api.nvim_create_user_command("SetColumnWidth100", function()
  vim.opt.colorcolumn = "100"
end, {})
