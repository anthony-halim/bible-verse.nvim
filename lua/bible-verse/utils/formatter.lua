local M = {}

local sup_nums = {
	["0"] = "⁰",
	["1"] = "¹",
	["2"] = "²",
	["3"] = "³",
	["4"] = "⁴",
	["5"] = "⁵",
	["6"] = "⁶",
	["7"] = "⁷",
	["8"] = "⁸",
	["9"] = "⁹",
}

--- Convert to super script
---@param num string integer to convert
---@return string supscript_num num in super script
function M.to_sup_num(num)
	local str_tbl = {}
	for c in num:gmatch(".") do
		table.insert(str_tbl, sup_nums[c])
	end
	return table.concat(str_tbl)
end

--- Format verses_table by book:chapter.
---@param verses_table DiathekeVerse[] parsed diatheke output.
---@return table<string, DiathekeVerse[]> verses_book_chapter parsed diatheke output
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

	local lines, whitespace_re, start = {}, "()%s+()", 1
	for _, str in ipairs(str_arr) do
		if str:len() <= limit then
			table.insert(lines, str)
		else
			str:gsub(whitespace_re, function(whitespace_start_idx, whitespace_end_idx)
				if whitespace_start_idx - start > limit then
					table.insert(lines, str:sub(start, whitespace_start_idx))
					start = whitespace_end_idx
				end
			end)
			table.insert(lines, str:sub(start))
		end
	end

	return lines
end

return M
