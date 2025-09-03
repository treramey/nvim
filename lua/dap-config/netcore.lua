local M = {}

--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co, path)
	vim.notify("Building project")
	vim.fn.jobstart(string.format("dotnet build %s", path), {
		on_exit = function(_, return_code)
			if return_code == 0 then
				vim.notify("Built successfully")
			else
				vim.notify("Build failed with exit code " .. return_code)
			end
			coroutine.resume(co)
		end,
	})
	coroutine.yield()
end

M.register_net_dap = function()
	local dap = require("dap")
	local dotnet = require("easy-dotnet")
	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

	local netcoredbg_adapter = {
		type = "executable",
		command = mason_path,
		args = { "--interpreter=vscode" },
	}
	local function file_exists(path)
		local stat = vim.loop.fs_stat(path)
		return stat and stat.type == "file"
	end

	local debug_dll = nil
	local function ensure_dll()
		if debug_dll ~= nil then
			return debug_dll
		end
		local dll = dotnet.get_debug_dll()
		debug_dll = dll
		return dll
	end

	dap.configurations.cs = {
		{
			name = "Launch .NET Core",
			type = "coreclr",
			request = "launch",
			env = function()
				local dll = ensure_dll()
				-- Reads the launchsettingsjson file looking for a profile with the name of your project
				local raw_vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)

				if not raw_vars then
					vim.notify("No environment variables found by get_environment_variables", vim.log.levels.WARN)
					return nil
				end

				-- netcoredbg expects strings, parse raw values to properly handle booleans types
				local vars = {}
				for key, value in pairs(raw_vars) do
					vars[key] = tostring(value)
				end
				return vars
			end,
			program = function()
				local dll = ensure_dll()
				local co = coroutine.running()
				rebuild_project(co, dll.project_path)
				if not file_exists(dll.target_path) then
					error("Project has not been built, path: " .. dll.target_path)
				end
				return dll.relative_dll_path
			end,
			cwd = function()
				local dll = ensure_dll()
				return dll.relative_project_path
			end,
			stopOnEntry = false,
			justMyCode = true,
			console = "integratedTerminal",
		},
	}

	dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
		debug_dll = nil
	end

	dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
	dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging
end

return M
