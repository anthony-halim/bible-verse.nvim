local M = {}

---@alias BibleVerseHLConfig table<FormatterType, table<string, _BibleVerseHLSettings>>

---@class _BibleVerseHLSettings
---@field pattern string
---@field hlgroup string

---@type BibleVerseHLConfig
M.defaults = {
	bibleverse = {
		book_chapter = {
			pattern = "",
			hlgroup = "Title",
		},
		verse_number = {
			pattern = "",
			hlgroup = "Number",
		},
		translation = {
			pattern = "",
			hlgroup = "ModeMsg",
		},
		separator = {
			pattern = "",
			hlgroup = "NonText",
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
		separator = {
			pattern = "()sp{([%S ]+)}()",
		},
	},
}

return M
