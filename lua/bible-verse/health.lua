local utils = require("bible-verse.utils")

local M = {}

--- Check if dependency exist.
---@param f function Signature: (string) -> boolean. To check dependency existence.
---@param dep_name string name of the dependency, to be fed as argument to the function.
---@param severity "warn"|"error" severity to display if dependency does not exist.
local function check_exist(f, dep_name, severity)
	if f(dep_name) then
		vim.health.ok(string.format("%s is installed", dep_name))
	else
		vim.health[severity](string.format("%s is not installed", dep_name))
	end
end

--- Check if Neovim fulfill minimum version.
---@param minimum_major integer major minimum version
---@param minimum_minor integer minor minimum version
---@param minimum_patch integer patch minimum version
---@param severity "warn"|"error" severity to display if dependency does not exist.
local function check_nvim_version(minimum_major, minimum_minor, minimum_patch, severity)
	local vim_version = vim.version()
	local min_version_str = string.format("%d.%d.%d", minimum_major, minimum_minor, minimum_patch)
	local is_fulfill_min_ver = vim_version.major >= minimum_major
		and vim_version.minor >= minimum_minor
		and vim_version.patch >= minimum_patch

	if is_fulfill_min_ver then
		vim.health.ok(string.format("Using Neovim >= %s", min_version_str))
	else
		vim.health[severity](string.format("Neovim version needs to be >= %s", min_version_str))
	end
end

M.check = function()
	check_nvim_version(0, 9, 0, "error")
	check_exist(utils.check_command_exist, "diatheke", "error")
	check_exist(utils.check_lua_module_exist, "nui.popup", "error")
	check_exist(utils.check_lua_module_exist, "nui.input", "error")
	check_exist(utils.check_lua_module_exist, "nui.utils.autocmd", "error")
end

return M
