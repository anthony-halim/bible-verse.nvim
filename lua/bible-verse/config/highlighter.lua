local M = {}

---@class BibleVerseHLConfig
---@field bibleverse BibleVerseHLBibleVerseConfig

---@class _BibleVerseHLSettings
---@field pattern? string
---@field color string[]
---@field modifier string

---@class BibleVerseHLBibleVerseConfig
---@field book _BibleVerseHLSettings
---@field chapter _BibleVerseHLSettings
---@field verse_number _BibleVerseHLSettings
---@field translation _BibleVerseHLSettings

---@type BibleVerseHLConfig
M.defaults = {
	---@type BibleVerseHLBibleVerseConfig
	bibleverse = {
		book = {
			color = {},
			modifier = "",
		},
		chapter = {
			color = {},
			modifier = "",
		},
		verse_number = {
			color = {},
			modifier = "",
		},
		translation = {
			color = {},
			modifier = "",
		},
	},
}

---@type BibleVerseHLConfig
---@diagnostic disable:missing-fields
M._default_override = {
	bibleverse = {
		book = {
			pattern = "",
		},
		chapter = {
			pattern = "",
		},
		verse_number = {
			pattern = "",
		},
		translation = {
			pattern = "",
		},
	},
}

return M
