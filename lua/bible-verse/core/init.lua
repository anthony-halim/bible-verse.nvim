local Config = require("bible-verse.config")
local Formatter = require("bible-verse.formatter")
local FormatterUtil = require("bible-verse.utils.formatter")
local Utils = require("bible-verse.utils")
local Diatheke = require("bible-verse.core.diatheke")
local Ui = require("bible-verse.core.ui")

local M = {}

--- Process query within diatheke and return formatted output
---@param query string query to diatheke
---@param formatter_type FormatterType type of formatter to be used
---@param output_wrap_line_at number wrap output at given character length. Set to 0 to disable.
---@return string[] output table of individual lines of the output.
local function process_query(query, formatter_type, output_wrap_line_at)
	local ok, res_or_err =
		pcall(Diatheke.call, Config.options.diatheke.translation, "plain", Config.options.diatheke.locale, query)
	if not ok then
		error("query returned error|err=" .. res_or_err)
	end
	local output = Formatter.format(res_or_err, formatter_type)
	return FormatterUtil.wrap(output, output_wrap_line_at)
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
	-- Handle UI config
	local input_conf = vim.deepcopy(Config.options.ui.query_input)
	local window_size = Utils.get_win_size()

	local border_text_len =
		math.max(string.len(input_conf.border.text.top or ""), string.len(input_conf.border.text.bottom or ""))

	input_conf.size.width = Utils.clamp(border_text_len, window_size.width, input_conf.size.max_width)

	-- On submit function
	local on_submit = function(input)
		if input and string.len(input) > 0 then
			window_size = Utils.get_win_size()
			local popup_conf = vim.deepcopy(Config.options.ui.popup)

			local popup_width = math.ceil(
				math.min(
					window_size.width * popup_conf.size.window_max_width_percentage,
					window_size.width * popup_conf.size.window_width_percentage
				)
			)
			local popup_max_height = math.ceil(window_size.height * popup_conf.size.window_max_height_percentage)

			local query_result = process_query(input, Config.options.query_format, popup_width)

			popup_conf.size.width = popup_width
			popup_conf.size.height = Utils.clamp(#query_result, 1, popup_max_height)

			Ui:popup(popup_conf, query_result)
		end
	end

	Ui:input(input_conf, on_submit)
end

--- Prompt for user input and insert it below the cursor
function M.query_and_insert()
	-- Handle UI config
	local input_conf = vim.deepcopy(Config.options.ui.insert_input)
	local window_size = Utils.get_win_size()

	local border_text_len =
		math.max(string.len(input_conf.border.text.top or ""), string.len(input_conf.border.text.bottom or ""))

	input_conf.size.width = Utils.clamp(border_text_len, window_size.width, input_conf.size.max_width)

	-- On submit function
	local on_submit = function(input)
		if input and string.len(input) > 0 then
			local query_result = process_query(input, Config.options.insert_format, 0)
			local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
			vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, query_result)
		end
	end

	Ui:input(input_conf, on_submit)
end

return M
