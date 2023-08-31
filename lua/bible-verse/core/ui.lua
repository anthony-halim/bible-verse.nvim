local NuiInput = require("nui.input")
local NuiPopup = require("nui.popup")
local NuiEvent = require("nui.utils.autocmd").event

local M = {
	input_ui = nil,
	popup_ui = nil,
}

---Take user input and call on_submit on submission.
---@param config NuiInputOptions
---@param on_submit function Signature: (input|nil) -> nil. Execute on user submission
---@param on_mount? fun(winid: integer): nil execute on popup mount
---@param on_unmount? fun(winid: integer): nil execute on popup dismount
function M:input(config, on_submit, on_mount, on_unmount)
	local cleanup = function()
		if self.input_ui then
			self.input_ui:unmount()
			if on_unmount then
				on_unmount(self.input_ui.winid)
			end
			self.input_ui = nil
		end
	end

	-- Cleanup previous instance, if any
	cleanup()

	-- Create new instance
	self.input_ui = NuiInput(config, {
		prompt = "", -- Use prompt as border text
		on_submit = function(input)
			on_submit(input)
			cleanup()
		end,
	})

	-- Set exit behaviour
	self.input_ui:map("n", "<Esc>", function()
		cleanup()
	end, { noremap = true })
	self.input_ui:on(NuiEvent.BufLeave, function()
		cleanup()
	end, { once = true })

	if on_mount then
		on_mount(self.input_ui.winid)
	end

	self.input_ui:mount()
end

---Show message as a pop up window.
---@param config NuiPopupOptions
---@param message_table string[] table of individual lines to be shown.
---@param on_mount? fun(winid: integer): nil execute on popup mount
---@param on_unmount? fun(winid: integer): nil execute on popup dismount
function M:popup(config, message_table, on_mount, on_unmount)
	local cleanup = function()
		if self.popup_ui then
			self.popup_ui:unmount()
			if on_unmount then
				on_unmount(self.popup_ui.winid)
			end
			self.popup_ui = nil
		end
	end

	-- Cleanup previous instance, if any
	cleanup()

	-- Create new instance
	self.popup_ui = NuiPopup(config)

	-- Set exit behaviour
	self.popup_ui:map("n", "<Esc>", function()
		cleanup()
	end, { noremap = true })
	self.popup_ui:map("n", "q", function()
		cleanup()
	end, { noremap = true })
	self.popup_ui:on(NuiEvent.BufLeave, function()
		cleanup()
	end, { once = true })

	-- Set content
	vim.api.nvim_buf_set_lines(self.popup_ui.bufnr, 0, 0, false, message_table)

	if on_mount then
		on_mount(self.popup_ui.winid)
	end

	self.popup_ui:mount()
end

return M
