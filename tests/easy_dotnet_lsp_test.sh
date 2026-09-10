#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../.." && pwd)
data_home=${XDG_DATA_HOME:-$HOME/.local/share}
host_mise_config=${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/bin" "$tmp/home/.local/share/mise/installs/dotnet/10" "$tmp/state" "$tmp/runtime"
printf '#!/bin/sh\nexit 0\n' > "$tmp/home/.local/share/mise/installs/dotnet/10/dotnet"
chmod +x "$tmp/home/.local/share/mise/installs/dotnet/10/dotnet"
cat > "$tmp/bin/dotnet-easydotnet" <<'EOF'
#!/bin/sh
if [ "${1:-}" = "roslyn" ]; then
  sleep 10
else
  printf '%s\n' 'test stub'
fi
EOF
chmod +x "$tmp/bin/dotnet-easydotnet"
touch "$tmp/test.cs"

export HOME="$tmp/home"
export XDG_CONFIG_HOME="$repo_root/home/dot_config"
export XDG_DATA_HOME="$data_home"
export XDG_STATE_HOME="$tmp/state"
export XDG_RUNTIME_DIR="$tmp/runtime"
export PATH="$tmp/home/.local/share/mise/installs/dotnet/10:$tmp/bin:$PATH"
if [[ -f "$host_mise_config" ]]; then
  export MISE_TRUSTED_CONFIG_PATHS="$host_mise_config"
fi

nvim --headless \
  --cmd 'lua package.loaded["mason-tool-installer"] = { setup = function(opts) _G.easy_dotnet_lsp_test_mason_opts = opts end }' \
  "$tmp/test.cs" \
  "+luafile $repo_root/home/dot_config/nvim/tests/easy_dotnet_lsp_spec.lua" \
  '+qa'
