local M = {}

---@class BibleVerseConfig
---@field default_behaviour? BibleVerseCmd
---@field insert_format? FormatterType
---@field diatheke BibleVerseDiathekeConfig
---@field ui? BibleVerseUiConfig
---@field formatter? BibleVerseFmtConfig

---@type BibleVerseConfig
M.defaults = {
	-- default_behaviour: behaviour to be used on empty command arg, i.e. :BibleVerse. Defaults to query.
	--     Options: "query" - on verse query, display the result on the screen as a popup.
	--              "insert" - on verse query, insert the result below the cursor of the current buffer.
	default_behaviour = "query",

	-- insert_format: text format on 'insert' behaviour.
	--     Options: "markdown" - insert as markdown formatted text.
	--              "plain" - insert as plain text.
	insert_format = "markdown",

	diatheke = require("bible-verse.config.diatheke").defaults,
	formatter = require("bible-verse.config.formatter").defaults,
	ui = require("bible-verse.config.ui").defaults,
}

---@type BibleVerseConfig
---@diagnostic disable-next-line:missing-fields
M.options = {}

---@param opts? BibleVerseConfig options to override.
function M.setup(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", M.defaults, opts)

	-- Assert config is sane
	assert(
		M.options.insert_format == "markdown" or M.options.insert_format == "plain",
		"unsupported_opts|insert_format=" .. M.options.insert_format
	)
end

return M
