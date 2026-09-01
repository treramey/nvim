local source = debug.getinfo(1, "S").source:sub(2)
local config_root = vim.fs.dirname(vim.fs.dirname(source))
package.path = config_root .. "/lua/?.lua;" .. config_root .. "/lua/?/init.lua;" .. package.path

local Catalog = require "treramey.theme_catalog"
local Switcher = require "treramey.theme_switcher"

local function assert_equal(actual, expected)
  assert(actual == expected, ("expected %q, got %q"):format(expected, actual))
end

assert_equal(Switcher.current_slug(), "rose-pine-main")
assert_equal(table.concat(Switcher.slugs(), ","), table.concat(Catalog.slugs(), ","))

local catalog_specs = Catalog.pack_specs()
local switcher_specs = Switcher.pack_specs()
assert_equal(#switcher_specs, #catalog_specs)
for index, catalog_spec in ipairs(catalog_specs) do
  local switcher_spec = switcher_specs[index]
  assert_equal(switcher_spec.src, catalog_spec.src)
  assert_equal(switcher_spec.name, catalog_spec.name)
  assert_equal(switcher_spec.version, catalog_spec.version)
end

print "theme_switcher_startup_spec: ok"
