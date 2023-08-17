local M = {}

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

return M
