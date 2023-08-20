local Config = require("bible-verse.config")
local FormatterCommon = require("bible-verse.formatter.common")

local M = {}

--- Formats parsed diatheke output and format it in Markdown style.
---@param verses_table DiathekeVerse[] parsed diatheke output.
---@return string[] output individual lines of the output.
function M.format(verses_table)
	local res = {}
	local by_bible_chapter = FormatterCommon.organise_by_bible_chapter(verses_table)
	local use_separator = string.len(Config.options.formatter.markdown.separator) ~= 0

	if use_separator then
		table.insert(res, Config.options.formatter.markdown.separator)
		table.insert(res, "")
	end
	for chapter_name, verses in pairs(by_bible_chapter) do
		table.insert(res, string.format("**%s**", chapter_name))
		table.insert(res, "")
		local chapter_res = {}
		for _, verse in ipairs(verses) do
			table.insert(chapter_res, string.format("<sup>%s</sup>%s", verse.verse_number, verse.verse))
		end
		table.insert(res, table.concat(chapter_res))
	end
	if not Config.options.formatter.markdown.omit_translation_footnote then
		table.insert(res, "")
		table.insert(res, string.format("<sub>*%s*</sub>", Config.options.diatheke.translation))
	end
	if use_separator then
		table.insert(res, "")
		table.insert(res, Config.options.formatter.markdown.separator)
	end

	return res
end

return M
