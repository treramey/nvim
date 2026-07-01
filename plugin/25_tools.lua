local update_script = [[
set -euo pipefail

mise upgrade --yes
mise install
mise reshim

if command -v dotnet >/dev/null 2>&1; then
  # Roslyn's tool package is prerelease-only, so normal updates do not see it.
  dotnet tool update -g roslyn-language-server --prerelease || true
  dotnet tool update -g dotnet-ef || true
  dotnet tool update -g EasyDotnet || true
fi

echo
echo "Tool update complete. Restart Neovim or run :LspRestart for active clients."
]]

local open_tool_update = function()
  vim.cmd "tabnew"
  vim.bo.bufhidden = "wipe"
  vim.bo.filetype = "terminal"

  -- Keep external LSPs, formatters, and CLIs managed by mise while Neovim uses
  -- native vim.lsp/vim.pack for runtime configuration and plugin management.
  vim.fn.termopen { "bash", "-lc", update_script .. [[
printf '\nPress enter to close... '
read -r _
]] }

  vim.cmd "startinsert"
end

pcall(vim.api.nvim_del_user_command, "ToolUpdate")
pcall(vim.api.nvim_del_user_command, "UpdateTools")
vim.api.nvim_create_user_command("UpdateTools", open_tool_update, {
  desc = "Update mise-managed LSPs, formatters, and CLI tools",
})
