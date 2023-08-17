local M = {}

M.defaults = {
	markdown = {
		separator = "---",
		omit_module_name = false,
	},

	plain = {
		header_delimiter = " ",
		omit_module_name = true,
	},
}

return M
