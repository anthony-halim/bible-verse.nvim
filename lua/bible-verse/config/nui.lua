local M = {}

M.defaults = {
	-- https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/input
	input = {
		border = {
			style = "rounded",
			padding = { 0, 1 },
			text = {
				top = "",
				top_align = "center",
			},
		},
		relative = "editor",
		position = "50%",
		size = {
			width = 50,
			height = 1,
		},
	},
	-- https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
	popup = {
		enter = true,
		focusable = true,
		border = {
			style = "rounded",
			padding = { 1, 1 },
			text = {
				top = "",
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
	},
}

return M
