local Utils = require("bible-verse.utils")

local M = {
	---@type table<integer, boolean>
	win_handlers = {},

	---@type table<integer, boolean>
	buf_handlers = {},
}

---@param win number window handler
function M:attach(win)
	local is_invalid_or_has_been_tracked = (not Utils.is_valid_win_and_buf(win)) or self.win_handlers[win]
	if is_invalid_or_has_been_tracked then
		return
	end

	local buf_handler = vim.api.nvim_win_get_buf(win)

	-- Fresh buffer to attach
	if not self.buf_handlers[buf_handler] then
		vim.api.nvim_buf_attach(buf_handler, false, {
			on_lines = function()
				-- Detach
				if not vim.api.nvim_buf_is_valid(buf_handler) then
					return true
				end
				-- TODO: Redraw
			end,
			on_detach = function()
				self.buf_handlers[buf_handler] = nil
			end,
		})
		self.buf_handlers[buf_handler] = true
	end

	-- Fresh window to attach
	if not self.win_handlers[win] then
		-- TODO: highlight
		self.win_handlers[win] = true
	end
end

---@param win number window handler
function M:detach(win)
	if Utils.is_valid_win_and_buf(win) then
		local buf_handler = vim.api.nvim_win_get_buf(win)
		self.buf_handlers[buf_handler] = nil
	end

	self.win_handlers[win] = nil
end

function M.highlight_win(win) end

---@param buf integer buffer handler
---@param ns integer namespace id
---@param first integer first line of range
---@param last integer last line of range
function M.highlight(buf, ns, first, last)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	vim.api.nvim_buf_clear_namespace(buf, ns, first, last + 1)

	local lines = vim.api.nvim_buf_get_lines(buf, first, last + 1, false)
end

return M
