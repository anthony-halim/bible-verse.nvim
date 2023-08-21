local Config = require("bible-verse.config")
local NuiInput = require("nui.input")
local NuiPopup = require("nui.popup")
local NuiEvent = require("nui.utils.autocmd").event

local M = {
	input_ui = nil,
	popup_ui = nil,
}

--- Create input component
---@param prompt string prompt to be used
---@param on_submit function Signature: (input|nil) -> nil. Execute on user submission
---@return table NuiInput
function M._create_input_ui(prompt, on_submit)
	local input_opts = vim.deepcopy(Config.options.nui.input)

	if input_opts then
		input_opts.border.text.top = prompt
		-- TODO: Override size.width: max 50, check for screen real estate
		input_opts.size.width = 50
	end

	local input_component = NuiInput(input_opts, {
		prompt = "", -- Use prompt as border text
		on_submit = on_submit,
	})

	-- Set exit behaviour
	input_component:map("n", "<Esc>", function()
		input_component:unmount()
	end, { noremap = true })
	input_component:on(NuiEvent.BufLeave, function()
		input_component:unmount()
	end, { once = true })

	return input_component
end

---Take user input and call on_submit on submission.
---@param prompt string prompt to be used
---@param on_submit function Signature: (input|nil) -> nil. Execute on user submission
function M:input(prompt, on_submit)
	if self.input_ui then
		-- unmount previous instance
		self.input_ui:unmount()
	end

	self.input_ui = M._create_input_ui(prompt, function(input)
		on_submit(input)
		self.input_ui = nil
	end)

	self.input_ui:mount()
end

---Create pop up window with message in it
---@param win_title string title of the pop up window
---@param message_table string[] table of individual lines to be shown.
---@return table NuiPopup
function M._create_popup_ui(win_title, message_table)
	local popup_opts = vim.deepcopy(Config.options.nui.popup)

	if popup_opts then
		popup_opts.border.text.top = win_title
		-- TODO: Override size.height, max: 70, check screen real estate
		popup_opts.size.height = "70%"
	end

	local popup_component = NuiPopup(popup_opts)

	-- Set exit behaviour
	popup_component:map("n", "<Esc>", function()
		popup_component:unmount()
	end, { noremap = true })
	popup_component:map("n", "q", function()
		popup_component:unmount()
	end, { noremap = true })
	popup_component:on(NuiEvent.BufLeave, function()
		popup_component:unmount()
	end, { once = true })

	-- Set content
	vim.api.nvim_buf_set_lines(popup_component.bufnr, 0, 0, false, message_table)

	return popup_component
end

---Show message as a pop up window.
---@param win_title string title of the pop up window
---@param message_table string[] table of individual lines to be shown.
function M:popup(win_title, message_table)
	if self.popup_ui then
		-- unmount previous instance
		self.popup_ui:unmount()
	end

	self.popup_ui = M._create_popup_ui(win_title, message_table)

	self.popup_ui:mount()
end

return M
