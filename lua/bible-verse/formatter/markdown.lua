local Config = require("bible-verse.config")
local FormatterUtil = require("bible-verse.utils.formatter")

local M = {}

--- Formats parsed diatheke output and format it in Markdown style.
---@param verses_table DiathekeVerse[] parsed diatheke output.
---@return string[] output individual lines of the output.
function M.format(verses_table)
	local res = {}
	local by_bible_chapter = FormatterUtil.organise_by_bible_chapter(verses_table)
	local use_separator = string.len(Config.options.formatter.markdown.separator) ~= 0
	local quote_block_char = ""
	if Config.options.formatter.markdown.quote_block then
		quote_block_char = "> "
	end
	if use_separator then
		table.insert(res, string.format("%s%s", quote_block_char, Config.options.formatter.markdown.separator))
		table.insert(res, string.format("%s", quote_block_char))
	end
	for chapter_name, verses in pairs(by_bible_chapter) do
		table.insert(res, string.format("%s**%s**", quote_block_char, chapter_name))
		table.insert(res, string.format("%s", quote_block_char))
		local chapter_res = {}
		for _, verse in ipairs(verses) do
			table.insert(chapter_res, string.format("<sup>%s</sup>%s ", verse.verse_number, verse.verse))
		end
		table.insert(res, string.format("%s%s", quote_block_char, table.concat(chapter_res)))
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
