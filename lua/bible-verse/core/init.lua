local Config = require("bible-verse.config")
local Ui = require("bible-verse.ui")
local Formatter = require("bible-verse.formatter")
local Diatheke = require("bible-verse.core.diatheke")

local M = {}

---@private
--- Process query within diatheke and return formatted output
---@param query string query to diatheke
---@param formatter_type "markdown"|"plain" (string) type of formatter to be used
---@return string[] output table of individual lines of the output.
function M._process_query(query, formatter_type)
	local ok, res_or_err =
		pcall(Diatheke.call, Config.options.diatheke.translation, "plain", Config.options.diatheke.locale, query)
	if not ok then
		error("query returned error|err=" .. res_or_err)
	end
	return Formatter.format(res_or_err, formatter_type)
end

--- Prompt for user input and show it back to the screen
function M.query_and_show()
	Ui.input("BibleVerse Query", function(input)
		if input and string.len(input) > 0 then
			local query_result = M._process_query(input, "plain")
			Ui.popup("BibleVerse", query_result)
		end
	end)
end

--- Prompt for user input and paste it below the cursor
function M.query_and_paste()
	Ui.input("BibleVerse Query (Paste)", function(input)
		if input and string.len(input) > 0 then
			local query_result = M._process_query(input, Config.options.paste_format)
			local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
			vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, query_result)
		end
	end)
end

return M