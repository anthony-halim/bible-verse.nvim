local Config = require("bible-verse.config")
local Utils = require("bible-verse.utils")

local M = {
	---@type table<integer, boolean>
	win_handlers = {},
}

--- NOTE: Very limited use cases.
--- Assumes that window only contains buffer that is not modifiable and is readonly.
--- Thus, we can simplify the implementation by not needing to listen to any buffer events (write, add, undo, redo, etc)
---
---@param win integer window handler
function M:attach(win)
	if not Utils.is_valid_win_and_buf(win, Config.options.exclude_buffer_filetypes) then
		vim.notify("Invalid window: " .. tostring(win))
		return
	end

	-- Fresh window to attach
	if not self.win_handlers[win] then
		vim.notify("Attaching to window: " .. tostring(win))
		self.win_handlers[win] = true
		M:highlight_win(win)
	end
end

---@param win integer window handler
function M:detach(win)
	vim.notify("Detaching from win:" .. tostring(win))
	self.win_handlers[win] = nil
end

--- PERF: As the plugin only shows ONE window per Neovim instance, performance is not optimised to the max.
---
---@param win number window handler
function M:highlight_win(win)
	if self.win_handlers[win] then
		local buf = vim.api.nvim_win_get_buf(win)
		local first = 0
		local last = vim.fn.line("$", win)
		-- local first = vim.fn.line("w0", win) -- First visible line
		-- local last = vim.fn.line("w$", win) -- Last visible line
		M.highlight(buf, first, last)
	end
end

---@param buf integer buffer handler
---@param first integer first line of range
---@param last integer last line of range
function M.highlight(buf, first, last)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	vim.api.nvim_buf_clear_namespace(buf, Config.ns, first, last + 1)

	local lines = vim.api.nvim_buf_get_lines(buf, first, last + 1, false)

	local last_match
end

return M
