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
--- On wrapping, we append the next line automatically.
--- To disable this behaviour, set disable_prepend_on_wrap to false.
---@param str_arr string[] output to wrap
---@param limit number character length
---@return string[] output that is wrapped
function M.wrap(str_arr, limit)
	if limit <= 0 then
		return str_arr
	end

	-- https://www.computercraft.info/forums2/index.php?/topic/15790-modifying-a-word-wrapping-function/
	local whitespace_re = "(%s+)()(%S+)()"
	local lines = {}

	local function split_until_below_limit()
		while #lines[#lines] < limit do
			lines[#lines + 1] = lines[#lines]:sub(limit + 1)
		end
	end

	for _, str in ipairs(str_arr) do
		-- Only wrap on length exceeding limit or on whitespace
		if (str:len() <= limit) or (not str:find(whitespace_re)) then
			lines[#lines + 1] = str
		else
			local here = 1

			str:gsub(whitespace_re, function(sp, st, word, fi) -- Function gets called once for every space
				split_until_below_limit()
				if fi - here > limit then
					here = st
					lines[#lines + 1] = word
				else
					lines[#lines] = lines[#lines] .. " " .. word
				end
			end)

			split_until_below_limit()
		end
	end

	return lines
end

return M
