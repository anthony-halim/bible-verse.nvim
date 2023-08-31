local M = {}

---@param cmd string
---@return boolean exists
function M.command_exists(cmd)
	return vim.fn.executable(cmd) ~= 0
end

---@param mod string
---@return boolean exists
function M.module_exists(mod)
	return pcall(_G.require, mod) == true
end

---@param x number
---@param min number
---@param max number
---@return number clamped
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

---@param win number window handler
function M.is_valid_win_and_buf(win)
	local is_valid_win = vim.api.nvim_win_is_valid(win)
	local is_valid_buf = is_valid_win and vim.api.nvim_buf_is_valid(vim.api.nvim_win_get_buf(win))
	return is_valid_win and is_valid_buf
end

return M
