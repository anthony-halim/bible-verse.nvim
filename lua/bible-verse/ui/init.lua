local Config = require("bible-verse.config")
local NuiInput = require("nui.input")
local NuiPopup = require("nui.popup")
local NuiEvent = require("nui.utils.autocmd").event

local M = {}

---Take user input and call on_submit on submission.
---@param prompt string prompt to be used
---@param on_submit function Signature: (input|nil) -> nil. Execute on user submission
function M.input(prompt, on_submit)
	local input_opts = vim.deepcopy(Config.options.nui.input)

	-- TODO: Override size.width and size.height
	input_opts.border.text.top = prompt

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

	-- TODO: Check if windows is still mounted
	input_component:mount()
end

---Show message as a pop up window.
---@param win_title string title of the pop up window
---@param message_table string[] table of individual lines to be shown.
function M.popup(win_title, message_table)
	local popup_opts = vim.deepcopy(Config.options.nui.popup)

	-- TODO: Override size.width and size.height
	popup_opts.border.text.top = win_title

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

	-- TODO: Check if windows is still mounted
	popup_component:mount()
end

return M
