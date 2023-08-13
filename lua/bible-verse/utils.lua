local M = {}

--- Check if command exists
---@param command_name string module name
---@return boolean exist whether module exist
local function check_command_exist(command_name)
	return vim.fn.executable(command_name) ~= 0
end

--- Check if module exists
---@param module_name string module name
---@return boolean exist whether module exist
local function check_lua_module_exist(module_name)
	local ok, _ = pcall(require, module_name)
	return ok
end

M.check_lua_module_exist = check_lua_module_exist
M.check_command_exist = check_command_exist

return M
