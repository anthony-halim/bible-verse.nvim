local Config = require("bible-verse.config")
local FormatterCommon = require("bible-verse.formatter.common")

local M = {}

--- Formats parsed diatheke output and format it in Markdown style.
---@param verses_table DiathekeVerse[] parsed diatheke output.
---@return string[] output individual lines of the output.
function M.format(verses_table)
	local res = {}
	local sorted_bible_chapter = FormatterCommon.organise_by_sorted_bible_chapter(verses_table)
	local sorted_bible_chapter_len = #sorted_bible_chapter
	local use_separator = string.len(Config.options.formatter.markdown.separator) ~= 0
	local quote_block_char = ""

	if Config.options.formatter.markdown.quote_block then
		quote_block_char = "> "
	end
	if use_separator then
		table.insert(res, string.format("%s%s", quote_block_char, Config.options.formatter.markdown.separator))
		table.insert(res, string.format("%s", quote_block_char))
	end
	for idx, sorted_chap in ipairs(sorted_bible_chapter) do
		table.insert(res, string.format("%s**%s**", quote_block_char, sorted_chap.name))
		table.insert(res, string.format("%s", quote_block_char))

		local chapter_res = {}
		for _, verse in ipairs(sorted_chap.verses) do
			table.insert(chapter_res, string.format("<sup>%s</sup>%s ", verse.verse_number, verse.verse))
		end
		table.insert(res, string.format("%s%s", quote_block_char, table.concat(chapter_res)))

		if idx < sorted_bible_chapter_len then
			table.insert(res, string.format("%s", quote_block_char))
		end
	end
	if not Config.options.formatter.markdown.omit_translation_footnote then
		table.insert(res, string.format("%s", quote_block_char))
		table.insert(res, string.format("%s<sub>*%s*</sub>", quote_block_char, Config.options.diatheke.translation))
	end
	if use_separator then
		table.insert(res, string.format("%s", quote_block_char))
		table.insert(res, string.format("%s%s", quote_block_char, Config.options.formatter.markdown.separator))
	end

	return res
end

return M
