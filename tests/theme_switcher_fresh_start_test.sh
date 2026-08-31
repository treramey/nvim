#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../.." && pwd)
host_config_home=${XDG_CONFIG_HOME:-$HOME/.config}
data_home=${XDG_DATA_HOME:-$HOME/.local/share}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/home/.cache" "$tmp/state" "$tmp/runtime"
printf 'rose-pine\n' > "$tmp/home/.cache/nvim-theme-trigger"

export HOME="$tmp/home"
export XDG_CONFIG_HOME="$repo_root/home/dot_config"
export XDG_DATA_HOME="$data_home"
export XDG_STATE_HOME="$tmp/state"
export XDG_RUNTIME_DIR="$tmp/runtime"

if [[ -f "$host_config_home/mise/config.toml" ]]; then
  export MISE_TRUSTED_CONFIG_PATHS="$host_config_home/mise/config.toml"
fi

nvim --headless \
  '+lua assert(vim.g.colors_name_slug == "rose-pine-dawn", vim.inspect(vim.g.colors_name_slug))' \
  '+lua vim.api.nvim_set_hl(0, "StatusLine", { bg = 0x123456 }); vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "aether", modeline = false }); vim.wait(100); assert(vim.api.nvim_get_hl(0, { name = "StatusLine", link = false }).bg == nil, "StatusLine background was not restored to transparent")' \
  '+qa'
