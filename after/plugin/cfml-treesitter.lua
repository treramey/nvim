-- Register cfml parser before nvim-treesitter FileType autocmd fires
local parsers = package.loaded["nvim-treesitter.parsers"] or require("nvim-treesitter.parsers")
if not parsers.cfml then
  parsers.cfml = {
    install_info = {
      url = "https://github.com/cfmleditor/tree-sitter-cfml",
      files = { "cfml/src/parser.c", "cfml/src/scanner.c" },
      location = "cfml",
      revision = "master",
    },
    filetype = "cfml",
    tier = 3,
  }
end
