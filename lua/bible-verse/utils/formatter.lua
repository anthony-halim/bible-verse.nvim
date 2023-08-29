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

---@param str_arr string[] output to wrap
---@param limit number character length
---@return string[] output that is wrapped
function M.wrap(str_arr, limit)
	if limit <= 0 then
		return str_arr
	end

	local whitespace_re = "()%s+()"
	local lines = {}

	for _, str in ipairs(str_arr) do
		if str:len() <= limit then
			table.insert(lines, str)
			goto continue
		end

		local start = 1

        -- Executes on whitespaces
		str:gsub(whitespace_re, function(whitespace_start_idx, whitespace_end_idx)
			if whitespace_start_idx - start > limit then
				lines[#lines + 1] = str:sub(start, whitespace_end_idx)
				start = whitespace_end_idx
			end
		end)
        lines[#lines + 1] = str:sub(start)

		::continue::
	end

	return lines
end

return M
