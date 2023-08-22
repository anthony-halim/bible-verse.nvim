local M = {}

---@class BibleVerseNuiConfig
---@field input? table
---@field popup? table

---@type BibleVerseNuiConfig
M.defaults = {
	-- input: configuration for input component, extending from Nui configuration.
	-- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/input
	input = {
		border = {
			style = "rounded",
			padding = { 0, 1 },
			text = {
				top_align = "center",
			},
		},
		position = "50%",
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	},
	-- popup: configuration for popup component, extending from Nui configuration.
	-- see: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
	popup = {
		border = {
			style = "rounded",
			padding = { 1, 1 },
			text = {
				top_align = "center",
			},
		},
		position = "50%",
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	},
}

M._default_override = {
	input = {
		enter = true,
		focusable = true,
		size = {
			height = 1,
		},
		zindex = 60, -- Must be > popup.zindex
		relative = "win",
	},

	popup = {
		enter = true,
		focusable = true,
		size = {},
		zindex = 50,
		relative = "win",
		buf_options = {
			modifiable = false,
			readonly = true,
		},
	},
}

return M
