local Utils = require("bible-verse.utils")
local Config = require("bible-verse.config")
local NuiInput = require("nui.input")
local NuiPopup = require("nui.popup")
local NuiEvent = require("nui.utils.autocmd").event

local M = {
	insert_input_ui = nil,
	paste_input_ui = nil,
	popup_ui = nil,
}

--- Create input component
---@param on_submit function Signature: (input|nil) -> nil. Execute on user submission
---@param config NuiInputOptions
---@return table NuiInput
function M._create_input_ui(on_submit, config)
	local window_size = Utils.get_win_size()

	local border_text_len =
		math.max(string.len(config.border.text.top or ""), string.len(config.border.text.bottom or ""))

	config.size.width = Utils.clamp(window_size.width, border_text_len, config.size.max_width)

	local input_component = NuiInput(config, {
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

---Create pop up window with message in it
---@param win_title string title of the pop up window
---@param message_table string[] table of individual lines to be shown.
---@return table NuiPopup
function M._create_popup_ui(win_title, message_table)
	local popup_opts = vim.deepcopy(Config.options.ui.popup)

	if not popup_opts then
		error("unable_to_get_nui_popup_configs")
	end

	local window_size = Utils.get_win_size()

	local popup_base_width = math.ceil(window_size.width * popup_opts.size.window_width_percentage)
	local popup_max_width = math.ceil(window_size.width * popup_opts.size.window_max_width_percentage)

	local popup_base_height = #message_table
	local popup_max_height = math.ceil(window_size.height * popup_opts.size.window_max_height_percentage)

	popup_opts.border.text.top = win_title
	popup_opts.size = {
		width = math.min(popup_base_width, popup_max_width),
		height = math.min(popup_base_height, popup_max_height),
	}

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
