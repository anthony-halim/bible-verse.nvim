local M = {}

---@private
--- Parse raw diatheke output to the expected format.
--
--  Parsed output format:
--  {
--     {
--       book: name of book
--       chapter: name of chapter
--       verse_number: verse number
--       verse: verse content
--     },
--     ...
--   }
---@param output string diatheke output
---@return table verses refer above for the format.
function M._parse_raw_output(output)
	local verses = {}

	for s in output:gmatch("[^\r\n]+") do
		local _, _, book, chapter, verse_number, verse = string.find(s, "^(.*) ([0-9]+):([0-9]+): (.*)")
		if book and chapter and verse_number and verse then
			table.insert(verses, {
				book = book,
				chapter = chapter,
				verse_number = verse_number,
				verse = verse,
			})
		end
	end

	return verses
end

--- Call diatheke CLI and return the parsed output in the format of a table of tables.
--
-- Parsed output format:
-- {
--   {
--     book: name of book
--     chapter: name of chapter
--     verse_number: verse number
--     verse: verse content
--   },
--   ...
-- }
---@param translation string translation type of bible; corresponds to -b flag of diatheke. e.g. KJV, ISV
---@param format string output_format of diatheke; corresponds to -f flag of diatheke. e.g. plain, HTML
---@param locale string locale on the local machine. e.g. en
---@param query string query to diatheke.
---@return table verse_table refer above for the format.
function M.call(translation, format, locale, query)
	local command = string.format("diatheke -b %s -f %s -l %s -k %s", translation, format, locale, query)
	local command_output = vim.fn.system(command)
	if vim.v.shell_error ~= 0 then
		error("diatheke command return error|command=" .. command)
	end

	return M._parse_raw_output(command_output)
end

return M
