local Config = require("bible-verse.config")

local M = {}

--- Formats parsed diatheke output and format it in plain text format.
---@param verses_table table parsed diatheke output according to diatheke_wrapper.call.
---@return string[] output table of individual lines of the output.
function M.format(verses_table)
	local res = {}

	for _, verse in ipairs(verses_table) do
		table.insert(
			res,
			string.format(
				"%s %s:%s%s%s",
				verse.book,
				verse.chapter,
				verse.verse_number,
				Config.options.formatter.plain.header_delimiter,
				verse.verse
			)
		)
	end
	if not Config.options.formatter.plain.omit_module_name then
		table.insert(res, "")
		table.insert(res, Config.options.formatter.diatheke.translation)
	end

	return res
end

return M
