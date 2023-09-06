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
---@return boolean
function M.is_valid_buf(buf, exclude)
	exclude = exclude or {}

	if not vim.api.nvim_buf_is_valid(buf) then
		vim.notify("Invalid buffer: " .. tostring(buf))
		return false
	end

	-- Skip special buffers
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
	if buftype == "" and buftype == "quickfix" then
		vim.notify("Invalid buffer, buftype_invalid: " .. tostring(buf) .. "|buftype=" .. buftype)
		return false
	end

	local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
	if vim.tbl_contains(exclude, filetype) then
		vim.notify("Invalid buffer, filetype_invalid: " .. tostring(buf) .. "|filetype=" .. filetype)
		return false
	end

	return true
end

---@param win number window handler
---@return boolean
function M.is_valid_win(win)
	return vim.api.nvim_win_is_valid(win)
end

---@param s string trimmed leading and trailing whitespace
function M.trim(s)
	return s:match("^%s*(.*%S)") or ""
end

---@param str_arr string[] output to wrap
---@param limit number character length
---@return string[] output that is wrapped
function M.wrap(str_arr, limit)
	if limit <= 0 then
		return str_arr
	end

	local lines, whitespace_re = {}, "()%S+()"
	for _, str in ipairs(str_arr) do
		if str:len() <= limit then
			table.insert(lines, str)
		else
			local start = 1
			str:gsub(whitespace_re, function(word_start_idx, next_word_start_idx)
				if next_word_start_idx - start > limit and (word_start_idx - 1 - start > 0) then
					table.insert(lines, M.trim(str:sub(start, word_start_idx - 1)))
					start = word_start_idx
				end
			end)
			table.insert(lines, M.trim(str:sub(start)))
		end
	end

	return lines
end

return M
