local M = {}

---@package
--- Format verses_table by book:chapter.
--
-- Output:
-- {
--   [ book chapter ] = {
--     verses...
--   },
--   [ book chapter ] = {
--     verses...
--   }
-- }
---@param verses_table table parsed diatheke output
local function organise_by_bible_chapter(verses_table)
	local by_bible_chapter = {}
	for _, verse in ipairs(verses_table) do
		local book_chapter_name = string.format("%s %s", verse.book, verse.chapter)
		if by_bible_chapter[book_chapter_name] == nil then
			by_bible_chapter[book_chapter_name] = {}
		end
		table.insert(by_bible_chapter[book_chapter_name], verse)
	end
	return by_bible_chapter
end

--- Formats parsed diatheke output and format it in Markdown style.
---@param verses_table table parsed diatheke output according to diatheke_wrapper.call.
---@param translation string translation used for the verses table.
---@param separator string separator to include in before, after, and in between book chapters.
---@param omit_module_name boolean if true, exclude specificying translation from the output.
---@return table output table of individual lines of the output.
local function markdown(verses_table, translation, separator, omit_module_name)
	local res = {}
	local by_bible_chapter = organise_by_bible_chapter(verses_table)
	local use_separator = string.len(translation) ~= 0

	if use_separator then
		table.insert(res, separator)
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
	if not omit_module_name then
		table.insert(res, "")
		table.insert(res, string.format("<sub>*%s*</sub>", translation))
	end
	if use_separator then
		table.insert(res, "")
		table.insert(res, separator)
	end

	return res
end

--- Formats parsed diatheke output and format it in plain text format.
---@param verses_table table parsed diatheke output according to diatheke_wrapper.call.
---@param translation string translation used for the verses table.
---@param omit_module_name boolean if true, exclude specificying translation from the output.
---@param header_delimiter string delimiter to be used to separate verse number and verse.
---@return table output table of individual lines of the output.
local function plain(verses_table, translation, omit_module_name, header_delimiter)
	local res = {}

	for _, verse in ipairs(verses_table) do
		table.insert(
			res,
			string.format("%s %s:%s%s%s", verse.book, verse.chapter, verse.verse_number, header_delimiter, verse.verse)
		)
	end
	if not omit_module_name then
		table.insert(res, "")
		table.insert(res, translation)
	end

	return res
end

-- Register formatters
M.plain = plain
M.markdown = markdown

--- Check if there is corresponding formatter
---@param formatter_name string formatter name
---@return boolean exist there is corresponding formatter
M.has_formatter = function(formatter_name)
	return M[formatter_name] ~= nil
end

return M
