local M = {}

---@param cmd string
function M.command_exists(cmd)
	return vim.fn.executable(cmd) ~= 0
end

---@param mod string
function M.module_exists(mod)
	return pcall(_G.require, mod) == true
end

---@param x number
---@param min number
---@param max number
function M.clamp(x, min, max)
	return math.min(max, math.max(min, x))
end

---@param window? integer window handle. if empty, will be assumed to be 0 (current window)
---@return { width: integer, height: integer } size in number of cells
function M.get_win_size(window)
	local window_handler = window or 0
	return {
		width = vim.api.nvim_win_get_width(window_handler),
		height = vim.api.nvim_win_get_height(window_handler),
	}
end

return M
