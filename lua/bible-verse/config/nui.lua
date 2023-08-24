local M = {}

---@class BibleVerseNuiConfig
---@field input? NuiInputOptions
---@field popup? NuiPopupOptions

---@type BibleVerseNuiConfig
M.defaults = {
	-- input: configuration for input component, extending from Nui configuration.
	-- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/input
	input = {
		border = {
			style = "rounded",
			padding = { 0, 1 },
			-- Text will be shown on the top of border
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
			-- Text will be shown on the top of border
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

---@type BibleVerseNuiConfig
M._default_override = {
	input = {
		enter = true,
		focusable = true,
		size = {
			max_width_cell = 50,
			height = 1,
		},
		zindex = 60, -- Must be > popup.zindex
		relative = "win",
	},
	popup = {
		enter = true,
		focusable = true,
		size = {
			window_width_percentage = 0.5,
			window_max_width_percentage = 0.8,
			window_max_height_percentage = 0.7,
		},
		zindex = 50,
		relative = "win",
		buf_options = {
			modifiable = false,
			readonly = true,
		},
	},
}

return M
