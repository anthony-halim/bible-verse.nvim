local Config = require("bible-verse.config")
local Ui = require("bible-verse.ui")
local Formatter = require("bible-verse.formatter")
local Diatheke = require("bible-verse.core.diatheke")

local M = {}

--- Process query within diatheke and return formatted output
---@param query string query to diatheke
---@param formatter_type FormatterType type of formatter to be used
---@return string[] output table of individual lines of the output.
local function process_query(query, formatter_type)
	local ok, res_or_err =
		pcall(Diatheke.call, Config.options.diatheke.translation, "plain", Config.options.diatheke.locale, query)
	if not ok then
		error("query returned error|err=" .. res_or_err)
	end
	return Formatter.format(res_or_err, formatter_type)
end

function M.setup()
	-- Check that config is sane
	assert(
		Config.options.diatheke.translation and string.len(Config.options.diatheke.translation) > 0,
		"missing configuration|diatheke.translation"
	)
end

--- Prompt for user input and show it back to the screen
function M.query_and_show()
	Ui:input("BibleVerse Query", function(input)
		if input and string.len(input) > 0 then
			local query_result = process_query(input, "plain")
			Ui:popup("BibleVerse", query_result)
		end
	end)
end

--- Prompt for user input and insert it below the cursor
function M.query_and_insert()
	Ui:input("BibleVerse Query (Insert)", function(input)
		if input and string.len(input) > 0 then
			local query_result = process_query(input, Config.options.insert_format)
			local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
			vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, query_result)
		end
	end)
end

return M
