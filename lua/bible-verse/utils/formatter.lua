local M = {}

--- Format verses_table by book:chapter.
---@param verses_table table<string, DiathekeVerse[]> parsed diatheke output
function M.organise_by_bible_chapter(verses_table)
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

--- Wrap output at given character length.
---@param output string[] output to wrap
---@param length number character length
---@return string[] output that is wrapped
function M.wrap_output_at(output, length)
	if length <= 0 then
		error(string.format("unable to wrap output|invalid_length|length=%s", length))
	end
	local res = {}
	return output
end

return M
