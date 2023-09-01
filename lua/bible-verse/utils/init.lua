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

--- Get current window width and height.
--- If current window is a floating window, fallback to editor size.
---@param win? number window handle
---@param disable_floating_fallback_to_editor? boolean disable fallback
---@return { width: integer, height: integer } size in number of cells
function M.get_win_size(win, disable_floating_fallback_to_editor)
	win = win or vim.api.nvim_get_current_win()
	disable_floating_fallback_to_editor = disable_floating_fallback_to_editor == nil or true

	if vim.api.nvim_win_get_config(win).relative ~= "" and disable_floating_fallback_to_editor then
		return M.get_editor_size()
	else
		return {
			width = vim.api.nvim_win_get_width(win),
			height = vim.api.nvim_win_get_height(win),
		}
	end
end

---@return { width: integer, height: integer } size in number of cells
function M.get_editor_size()
	return {
		width = vim.o.columns,
		height = vim.o.lines,
	}
end

---@param type "'cursor'"|"'editor'"|"'win'"
---@return { width: integer, height: integer } size in number of cells
function M.get_relative_size(type)
	if type == "editor" then
		return M.get_editor_size()
	elseif type == "win" or type == "cursor" then
		return M.get_win_size()
	else
		-- Fallback
		return M.get_editor_size()
	end
end

---@param win number window handler
function M.is_valid_win_and_buf(win)
	local is_valid_win = vim.api.nvim_win_is_valid(win)
	local is_valid_buf = is_valid_win and vim.api.nvim_buf_is_valid(vim.api.nvim_win_get_buf(win))
	return is_valid_win and is_valid_buf
end

return M
