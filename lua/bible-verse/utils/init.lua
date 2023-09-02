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

---@param buf integer buffer handler
---@param exclude? string[] type of buffers to exclude
---@param must_be_modifiable? boolean force buffer to be modifiable
---@return boolean
function M.is_valid_buf(buf, exclude, must_be_modifiable)
	exclude = exclude or {}
	must_be_modifiable = must_be_modifiable == nil or false

	if not vim.api.nvim_buf_is_valid(buf) then
		return false
	end

	-- Skip special buffers
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
	if buftype ~= "" and buftype ~= "quickfix" then
		return false
	end

	local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
	if vim.tbl_contains(exclude, filetype) then
		return false
	end

	if must_be_modifiable and not vim.api.nvim_get_option_value("modifiable", { buf = buf }) then
		return false
	end

	return true
end

---@param win number window handler
---@return boolean
function M.is_valid_win(win)
	return vim.api.nvim_win_is_valid(win)
end

---@param win number window handler
---@param buf_type_exclude? string[] type of buffers to exclude
---@param buf_must_be_modifiable? boolean force buffer to be modifiable
function M.is_valid_win_and_buf(win, buf_type_exclude, buf_must_be_modifiable)
	if not M.is_valid_win(win) then
		return false
	end

	local buf = vim.api.nvim_win_get_buf(win)
	if not M.is_valid_buf(buf, buf_type_exclude, buf_must_be_modifiable) then
		return false
	end

	return true
end

return M
