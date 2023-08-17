local M = {}

local nui_input = require("nui.input")
local nui_popup = require("nui.popup")
local nui_event = require("nui.utils.autocmd").event

---Take user input and call on_submit on submission.
---@param prompt string prompt to be used
---@param on_submit function Signature: (input|nil) -> nil. Execute on user submission
local function input(prompt, on_submit)
	local input_opts = {
		border = {
			style = "rounded",
			padding = { 0, 1 },
			text = {
				top = prompt,
				top_align = "center",
			},
		},
		relative = "editor",
		position = "50%",
		size = {
			width = 50,
			height = 1,
		},
	}
	local input_component = nui_input(input_opts, {
		prompt = "", -- Use prompt as border text
		on_submit = on_submit,
	})

	-- Set exit behaviour
	input_component:map("n", "<Esc>", function()
		input_component:unmount()
	end, { noremap = true })
	input_component:on(nui_event.BufLeave, function()
		input_component:unmount()
	end, { once = true })

	input_component:mount()
end

---Show message as a pop up window.
---@param win_title string title of the pop up window
---@param message_table table table of individual lines to be shown.
local function popup(win_title, message_table)
	local popup_opts = {
		enter = true,
		focusable = true,
		border = {
			style = "rounded",
			padding = { 1, 1 },
			text = {
				top = win_title,
				top_align = "center",
			},
		},
		relative = "editor",
		position = "50%",
		size = {
			width = "80%",
			height = "70%",
		},
		buf_options = {
			modifiable = false,
			readonly = true,
		},
	}
	local popup_component = nui_popup(popup_opts)

	-- Set exit behaviour
	popup_component:map("n", "<Esc>", function()
		popup_component:unmount()
	end, { noremap = true })
	popup_component:map("n", "q", function()
		popup_component:unmount()
	end, { noremap = true })
	popup_component:on(nui_event.BufLeave, function()
		popup_component:unmount()
	end, { once = true })

	-- Set content
	vim.api.nvim_buf_set_lines(popup_component.bufnr, 0, 0, false, message_table)

	popup_component:mount()
end

M.input = input
M.popup = popup

return M
