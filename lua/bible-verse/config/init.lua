local M = {}

M.defaults = {
	default_behaviour = "query",
	paste_format = "markdown",
}
M.defaults.diatheke = require("bible-verse.config.diatheke").defaults
M.defaults.nui = require("bible-verse.config.nui").defaults
M.defaults.formatter = require("bible-verse.config.formatter").defaults

M.options = {}

---@param opts? table options to override.
function M.setup(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", M.defaults, opts)
end

return M
