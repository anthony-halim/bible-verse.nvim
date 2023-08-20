local M = {}

---@class BibleVerseFmtConfig
---@field markdown? BibleVerseFmtMarkdownConfig
---@field plain? BibleVerseFmtPlainConfig

---@class BibleVerseFmtMarkdownConfig
---@field separator? string
---@field omit_translation_footnote? boolean

---@class BibleVerseFmtPlainConfig
---@field header_delimiter? string
---@field omit_translation_footnote? boolean

---@type BibleVerseFmtConfig
M.defaults = {
	---@type BibleVerseFmtMarkdownConfig
	markdown = {
		-- separator: text to be used as prefix and suffix the markdown text. Set to empty string to disable.
		separator = "---",
		-- omit_translation_footnote: omit translation name from the markdown text.
		omit_translation_footnote = false,
	},

	---@type BibleVerseFmtPlainConfig
	plain = {
		-- header_delimiter: text to be used to separate between the content of verse and the verse.
		header_delimiter = " ",
		-- omit_translation_footnote: omit translation name from the plain text.
		omit_translation_footnote = true,
	},
}

return M
