return {
	"seblj/roslyn.nvim",
	lazy = false,
	enabled = true,
	config = function()
		require("roslyn").setup({
			dotnet_cmd = "dotnet", -- this is the default
			roslyn_version = "4.12.0-1.24372.10", -- this is the default
			capabilities = vim.tbl_deep_extend("force", capabilities or {}, {
				textDocument = {
					diagnostic = {
						dynamicRegistration = true,
					},
				},
			}),
			on_attach = function()
				vim.cmd([[compiler dotnet]])
			end,
			settings = {
				["csharp|inlay_hints"] = {
					["csharp_enable_inlay_hints_for_implicit_object_creation"] = true,
					["csharp_enable_inlay_hints_for_implicit_variable_types"] = true,
					["csharp_enable_inlay_hints_for_lambda_parameter_types"] = true,
					["csharp_enable_inlay_hints_for_types"] = true,
					["dotnet_enable_inlay_hints_for_indexer_parameters"] = true,
					["dotnet_enable_inlay_hints_for_literal_parameters"] = true,
					["dotnet_enable_inlay_hints_for_object_creation_parameters"] = true,
					["dotnet_enable_inlay_hints_for_other_parameters"] = true,
					["dotnet_enable_inlay_hints_for_parameters"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent"] = true,
				},
			},
		})
	end,
}
