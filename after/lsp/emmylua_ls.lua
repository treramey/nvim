-- Proper LSP settings for EmmyLua to avoid false "undefined global" warnings
-- and to integrate correctly with Neovim's Lua runtime and plugin libraries.
vim.api.nvim_set_hl(0, "@lsp.type.string.lua", { fg = "NONE" })

-- Only highlight documentation words, not the entire doc string.
vim.api.nvim_set_hl(0, "@lsp.mod.documentation.lua", { link = "Statement" })

return {
  settings = {
    emmylua = {
      diagnostics = {
        disable = { "undefined-global" },
      },
      runtime = { version = "LuaJIT" },
      workspace = {
        library = vim.list_extend({ vim.env.VIMRUNTIME }, vim.api.nvim_get_runtime_file("lua", true)),
        ignoreDir = { "dual", "deps" },
      },
    },
  },
}
