local M = {}

---@class BibleVerseConfig
---@field default_behaviour "query"|"paste"
---@field paste_format "markdown"|"plain"
---@field diatheke BibleVerseDiathekeConfig
---@field nui BibleVerseNuiConfig
---@field formatter BibleVerseFmtConfig

---@type BibleVerseConfig
M.defaults = {
	-- default_behaviour: behaviour to be used on empty command arg
	-- paste_format: text format on pasting
	default_behaviour = "query",
	paste_format = "markdown",
	diatheke = require("bible-verse.config.diatheke").defaults,
	nui = require("bible-verse.config.nui").defaults,
	formatter = require("bible-verse.config.formatter").defaults,
}

---@type BibleVerseConfig
---@diagnostic disable-next-line:missing-fields
M.options = {}

---@param opts? BibleVerseConfig options to override.
function M.setup(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", M.defaults, opts)
end

return M
