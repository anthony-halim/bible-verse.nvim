local M = {}

---@alias BibleVerseHLConfig table<FormatterType, table<string, _BibleVerseHLSettings>>

---@class _BibleVerseHLSettings
---@field pattern string
---@field color string[]
---@field modifier string

---@type BibleVerseHLConfig
M.defaults = {
	bibleverse = {
		book_chapter = {
			pattern = "",
			color = {},
			modifier = "",
		},
		verse_number = {
			pattern = "",
			color = {},
			modifier = "",
		},
		translation = {
			pattern = "",
			color = {},
			modifier = "",
		},
	},
}

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
