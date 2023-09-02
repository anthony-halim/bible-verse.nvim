local M = {}

---@class BibleVerseConfig
---@field default_behaviour BibleVerseCmd
---@field query_format "plain"|"bibleverse"
---@field insert_format "markdown"|"plain"
---@field exclude_buffer_filetypes string[]
---@field diatheke BibleVerseDiathekeConfig
---@field ui BibleVerseUiConfig
---@field formatter BibleVerseFmtConfig
---@field highlighter BibleVerseHLConfig
---@field ns? number
---@field aug? number

---@type BibleVerseConfig
M.defaults = {
	-- default_behaviour: behaviour to be used on empty command arg, i.e. :BibleVerse. Defaults to query.
	--     Options: "query" - on verse query, display the result on the screen as a popup.
	--              "insert" - on verse query, insert the result below the cursor of the current buffer.
	default_behaviour = "query",

	-- query_format: text format on 'query' behaviour.
	--     Options: "bibleverse" - query as bibleverse formatted text.
	--              "plain" - query as plain text.
	query_format = "bibleverse",

	-- insert_format: text format on 'insert' behaviour.
	--     Options: "markdown" - insert as markdown formatted text.
	--              "plain" - insert as plain text.
	insert_format = "markdown",

	-- Forbid plugin on the following buffer filetypes
	exclude_buffer_filetypes = { "neo-tree", "NvimTree" },

	diatheke = require("bible-verse.config.diatheke").defaults,
	formatter = require("bible-verse.config.formatter").defaults,
	ui = require("bible-verse.config.ui").defaults,
	highlighter = require("bible-verse.config.highlighter").defaults,
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
		vim.tbl_contains({ "bibleverse", "plain" }, M.options.query_format),
		"unsupported_opts|query_format=" .. M.options.query_format
	)
	assert(
		vim.tbl_contains({ "markdown", "plain" }, M.options.insert_format),
		"unsupported_opts|insert_format=" .. M.options.insert_format
	)

	M.options.highlighter =
		vim.tbl_deep_extend("force", M.options.highlighter, require("bible-verse.config.highlighter")._default_override)

	M.ns = vim.api.nvim_create_namespace("bible-verse-ns")
	M.aug = vim.api.nvim_create_augroup("bible-verse-aug", { clear = true })
end

return M
