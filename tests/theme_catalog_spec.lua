local source = debug.getinfo(1, "S").source:sub(2)
local config_root = vim.fs.dirname(vim.fs.dirname(source))
package.path = config_root .. "/lua/?.lua;" .. config_root .. "/lua/?/init.lua;" .. package.path

local Catalog = require "treramey.theme_catalog"

local function assert_equal(actual, expected)
  assert(actual == expected, ("expected %q, got %q"):format(expected, actual))
end

local result = Catalog.resolve "rose-pine"
assert(result.ok, "rose-pine should resolve")
assert_equal(result.value.tag, "alias")
assert_equal(result.value.slug, "rose-pine-dawn")

local canonical = Catalog.resolve "rose-pine-main"
assert(canonical.ok, "canonical slug should resolve")
assert_equal(canonical.value.tag, "canonical")
assert_equal(canonical.value.slug, "rose-pine-main")

for _, case in ipairs {
  { input = "", tag = "invalid-input", detail = "empty" },
  { input = "rose-pine\nmain", tag = "invalid-input", detail = "multiline" },
  { input = "not-a-theme", tag = "unsupported-theme", detail = "not-a-theme" },
} do
  local failure = Catalog.resolve(case.input)
  assert(not failure.ok, ("%q should fail"):format(case.input))
  assert_equal(failure.error.tag, case.tag)
  assert_equal(failure.error.reason or failure.error.input, case.detail)
end

local expected_slugs = {
  "boring",
  "bulwer-omarchy",
  "caroline-skyline",
  "catppuccin",
  "catppuccin-latte",
  "ethereal",
  "everforest",
  "flexoki-light",
  "gruvbox",
  "hackerman",
  "kanagawa",
  "kanagawa-dragon",
  "kanagawa-lotus",
  "kurayami",
  "lumon",
  "matte-black",
  "miasma",
  "nord",
  "osaka-jade",
  "retro-82",
  "ristretto",
  "rose-pine-dawn",
  "rose-pine-main",
  "thegreek",
  "tokyo-night",
  "vantablack",
  "white",
}
local actual_slugs = Catalog.slugs()
assert_equal(#actual_slugs, #expected_slugs)
for index, expected in ipairs(expected_slugs) do
  assert_equal(actual_slugs[index], expected)
end

local specs = Catalog.pack_specs()
assert_equal(#specs, 19)
local specs_by_source = {}
for _, spec in ipairs(specs) do
  specs_by_source[spec.src] = spec
end
for source, expected in pairs {
  ["https://github.com/bjarneo/aether.nvim"] = { name = "aether", version = "v3" },
  ["https://github.com/catppuccin/nvim"] = { name = "catppuccin" },
  ["https://github.com/rose-pine/neovim"] = { name = "rose-pine" },
} do
  local spec = assert(specs_by_source[source], "missing package spec for " .. source)
  assert_equal(spec.name, expected.name)
  assert_equal(spec.version, expected.version)
end

local conflict_ok, conflict_error = pcall(Catalog.project_pack_specs, {
  { src = "https://example.test/theme", name = "one", version = "v1" },
  { src = "https://example.test/theme", name = "two", version = "v1" },
})
assert(not conflict_ok, "conflicting plugin metadata should fail")
assert(tostring(conflict_error):find "conflicting%-plugin%-spec", "conflict should have a stable tag")

print "theme_catalog_spec: ok"
