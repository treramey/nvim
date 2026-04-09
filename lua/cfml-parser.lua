-- Register cfml parser for nvim-treesitter BEFORE lazy loads
local status_ok, parsers = pcall(require, "nvim-treesitter.parsers")
if status_ok and not parsers.cfml then
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
