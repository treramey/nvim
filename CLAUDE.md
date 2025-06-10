# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands
- Formatting: Use LSP format or conform.nvim formatters
  - Lua: stylua
  - JavaScript/TypeScript: biome
  - HTML/CSS/JSON/Markdown: prettier
  - C#: csharpier
  - Go: gofmt
  - HTML/JSX/TSX: rustywind
  - XML/SVG: xmlformat

## Code Style Guidelines
- **Naming**: Use snake_case for variables and functions in Lua
- **Formatting**: 
  - Use stylua for Lua files
  - Use "stylua: ignore start/end" to ignore formatting in sections
- **Configuration**: 
  - Prefer table literals for plugin configuration
  - Use proper block indentation
- **Comments**:
  - Use --- for document comments (@param, @diagnostic)
  - Use -- for regular comments
- **Error Handling**: 
  - Use vim.api.nvim_echo for error messages
  - Properly check for nil values before accessing

## Structure
- Put new plugins in lua/plugins/
- Put user configs in lua/user/
- Keep filetype-specific settings in after/ftplugin/