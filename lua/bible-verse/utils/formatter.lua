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
---@return { name: string, verses: DiathekeVerse[]}[] sorted_verse_table sorted output
function M.organise_by_sorted_bible_chapter(verses_table)
	local sorted_bible_chapter = {}
	for _, verse in ipairs(verses_table) do
		local book_chapter_name = string.format("%s %s", verse.book, verse.chapter)
		if
			sorted_bible_chapter[#sorted_bible_chapter] == nil
			or sorted_bible_chapter[#sorted_bible_chapter].name ~= book_chapter_name
		then
			table.insert(sorted_bible_chapter, {
				name = book_chapter_name,
				verses = {},
			})
		end
		table.insert(sorted_bible_chapter[#sorted_bible_chapter].verses, verse)
	end
	return sorted_bible_chapter
end

---@param str_arr string[] output to wrap
---@param limit number character length
---@return string[] output that is wrapped
function M.wrap(str_arr, limit)
	if limit <= 0 then
		return str_arr
	end

	local lines, whitespace_re = {}, "()%S+%s+()"
	for _, str in ipairs(str_arr) do
		if str:len() <= limit then
			table.insert(lines, str)
		else
			local start = 1
			str:gsub(whitespace_re, function(word_start_idx, next_word_start_idx)
				if next_word_start_idx - start > limit then
					table.insert(lines, str:sub(start, word_start_idx - 1))
					start = next_word_start_idx
				end
			end)
			table.insert(lines, str:sub(start))
		end
	end

	return lines
end

return M
