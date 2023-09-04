local M = {}

---@alias BibleVerseHLConfig table<FormatterType, table<string, _BibleVerseHLSettings>>

---@class _BibleVerseHLSettings
---@field pattern string
---@field color string[]

---@type BibleVerseHLConfig
M.defaults = {
	bibleverse = {
		book_chapter = {
			pattern = "",
			color = {},
		},
		verse_number = {
			pattern = "",
			color = {},
		},
		translation = {
			pattern = "",
			color = {},
		},
	},
}

---NOTE: pattern: must capture
--- (1) before pattern idx
--- (2) word to capture
--- (3) after pattern idx

---@type BibleVerseHLConfig
---@diagnostic disable:missing-fields
M._default_override = {
	bibleverse = {
		book_chapter = {
			pattern = "()bc{([%w ]+)}()",
		},
		verse_number = {
			pattern = "()vn{([%S]+)}()",
		},
		translation = {
			pattern = "()t{([%w ]+)}()",
		},
	},
}

return M
