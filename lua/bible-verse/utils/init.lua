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

--- Get current window width and height. If current window is a floating window, fallback to editor size.
---@param win? number window handler
---@return { width: integer, height: integer } size in number of cells
function M.get_win_size(win)
	local window_handler = win or vim.api.nvim_get_current_win()
	if vim.api.nvim_win_get_config(window_handler).relative ~= "" then
		return {
			width = vim.o.columns,
			height = vim.o.lines,
		}
	else
		return {
			width = vim.api.nvim_win_get_width(window_handler),
			height = vim.api.nvim_win_get_height(window_handler),
		}
	end
end

return M
