local Config = require("bible-verse.config")
local FormatterUtil = require("bible-verse.utils.formatter")

local M = {}

--- Formats parsed diatheke output and format it in Markdown style.
---@param verses_table DiathekeVerse[] parsed diatheke output.
---@return string[] output individual lines of the output.
function M.format(verses_table)
	local res = {}
	local sorted_bible_chapter = FormatterUtil.organise_by_sorted_bible_chapter(verses_table)
	local sorted_bible_chapter_len = #sorted_bible_chapter

	for idx, sorted_chap in ipairs(sorted_bible_chapter) do
		table.insert(res, string.format("%s", sorted_chap.name))
		table.insert(res, "")

		local chapter_res = {}
		for _, verse in ipairs(sorted_chap.verses) do
			table.insert(chapter_res, string.format("%s%s ", FormatterUtil.to_sup_num(verse.verse_number), verse.verse))
		end
		table.insert(res, table.concat(chapter_res))

		if idx < sorted_bible_chapter_len then
			table.insert(res, "")
		end
	end
	if not Config.options.formatter.bibleverse.omit_translation_footnote then
		table.insert(res, "")
		table.insert(res, string.format("%s", Config.options.diatheke.translation))
	end

	return res
end

return M
