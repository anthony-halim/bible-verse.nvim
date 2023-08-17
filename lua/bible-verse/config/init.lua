local M = {}

function M.defaults()
	local defaults = {
		default_behaviour = "query",
		paste_format = "markdown",

		diatheke = {
			translation = "ISV",
			locale = "en",
		},

		markdown = {
			separator = "---",
			omit_module_name = false,
		},

		plain = {
			header_delimiter = " ",
			omit_module_name = true,
		},
	}
	return defaults
end

M.options = {}

---@param opts? table options to override.
function M.setup(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", M.defaults(), opts)
end

return M
