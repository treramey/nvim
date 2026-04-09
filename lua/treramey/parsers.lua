vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if ok then
      parsers.cfml = {
        install_info = {
          url = "https://github.com/cfmleditor/tree-sitter-cfml",
          files = { "cfml/src/parser.c", "cfml/src/scanner.c" },
          location = "cfml",
          branch = "master",
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
      }
    end
  end,
})
