local M = {}

---@class BibleVerseDiathekeConfig
---@field translation string
---@field locale? string

---@type BibleVerseDiathekeConfig
M.defaults = {
	-- (MANDATORY) translation: diatheke module to be used.
	translation = "",
	-- locale: locale as locales in the machine.
	locale = "en",
}

return M
