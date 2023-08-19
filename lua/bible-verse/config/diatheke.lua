local M = {}

---@class BibleVerseDiathekeConfig
---@field translation string
---@field locale? string

---@type BibleVerseDiathekeConfig
M.defaults = {
	-- translation: diatheke module to be used.
	-- locale: locale as locales in the machine.
	translation = "",
	locale = "en",
}

return M
