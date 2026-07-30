local M = {}

local function github_source(source)
  if source:find("://", 1, true) or source:sub(1, 4) == "git@" then
    return source
  end
  return "https://github.com/" .. source
end

local function is_lazyvim(spec)
  return type(spec) == "table" and spec[1] == "LazyVim/LazyVim"
end

local function plugin_name(spec)
  if spec.main then
    return spec.main
  end

  local name = spec.name or spec[1]:match "([^/]+)$"
  name = name:gsub("%.nvim$", ""):gsub("%-nvim$", ""):gsub("^nvim%-", ""):gsub("%.vim$", "")
  return name
end

local function plugin_opts(spec)
  if type(spec.opts) == "function" then
    return spec.opts(spec, {}) or {}
  end
  return spec.opts
end

local function append_plugin(spec, plugins, packs, seen)
  if type(spec) == "string" then
    spec = { spec }
  end
  if type(spec) ~= "table" or type(spec[1]) ~= "string" or is_lazyvim(spec) then
    return
  end

  local dependencies = spec.dependencies
  if type(dependencies) == "string" then
    dependencies = { dependencies }
  end
  for _, dependency in ipairs(dependencies or {}) do
    append_plugin(dependency, plugins, packs, seen)
  end

  local source = github_source(spec[1])
  if seen[source] then
    return
  end
  seen[source] = true

  table.insert(packs, {
    src = source,
    name = spec.name,
    version = spec.version or spec.branch or spec.tag or spec.commit,
  })
  table.insert(plugins, spec)
end

function M.load(path, slug)
  if type(slug) ~= "string" or slug == "" or slug:find "[\r\n]" then
    return nil, "invalid Omarchy theme name"
  end
  if vim.fn.filereadable(path) ~= 1 then
    return nil, "missing Omarchy neovim.lua"
  end

  local chunk, load_error = loadfile(path)
  if not chunk then
    return nil, load_error
  end
  local ok, specs = pcall(chunk)
  if not ok then
    return nil, specs
  end
  if type(specs) ~= "table" then
    return nil, "Omarchy neovim.lua must return a plugin list"
  end

  local colorscheme
  local plugins, packs, seen = {}, {}, {}
  for _, spec in ipairs(specs) do
    if is_lazyvim(spec) then
      local opts = plugin_opts(spec)
      if type(opts) == "table" then
        colorscheme = opts.colorscheme or colorscheme
      end
    else
      append_plugin(spec, plugins, packs, seen)
    end
  end

  if type(colorscheme) ~= "string" or colorscheme == "" then
    return nil, "Omarchy neovim.lua does not declare opts.colorscheme"
  end
  if #packs == 0 then
    return nil, "Omarchy neovim.lua does not declare a theme plugin"
  end

  return {
    slug = slug,
    colorscheme = colorscheme,
    background = vim.fn.filereadable(vim.fs.dirname(path) .. "/light.mode") == 1 and "light" or "dark",
    pack_specs = packs,
    plugins = plugins,
  }
end

function M.setup(theme)
  for _, spec in ipairs(theme.plugins) do
    local opts = plugin_opts(spec)
    if type(spec.config) == "function" then
      local ok, err = pcall(spec.config, spec, opts)
      if not ok then
        return false, err
      end
    elseif opts ~= nil then
      local ok, plugin = pcall(require, plugin_name(spec))
      if not ok then
        return false, plugin
      end
      if type(plugin.setup) ~= "function" then
        return false, plugin_name(spec) .. " does not expose setup()"
      end
      local setup_ok, setup_error = pcall(plugin.setup, opts)
      if not setup_ok then
        return false, setup_error
      end
    end
  end
  return true
end

return M
