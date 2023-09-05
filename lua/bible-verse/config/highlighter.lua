local M = {}

---@alias BibleVerseHLConfig table<FormatterType, table<string, _BibleVerseHLSettings>>

---@class _BibleVerseHLSettings
---@field pattern string
---@field hlgroup string

---@type BibleVerseHLConfig
M.defaults = {
	-- highlighting for bibleverse text
	bibleverse = {
		-- highlighting for book and chapter of the output e.g. John 1
		book_chapter = {
			pattern = "",
			hlgroup = "Title", -- Highlight group to use to highlight the text
		},
		-- highlighting for verse number the output
		verse_number = { pattern = "", hlgroup = "Number" },
		-- highlighting for translation used in the output
		translation = { pattern = "", hlgroup = "ModeMsg" },
		-- highlighting for separator between book chapters used in the output
		separator = { pattern = "", hlgroup = "NonText" },
	},
}

---NOTE: pattern: must capture the following:
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
