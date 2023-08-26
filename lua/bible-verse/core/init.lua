local NuiInput = require("nui.input")
local NuiPopup = require("nui.popup")
local NuiEvent = require("nui.utils.autocmd").event

local Config = require("bible-verse.config")
local Formatter = require("bible-verse.formatter")
local Utils = require("bible-verse.utils")
local Diatheke = require("bible-verse.core.diatheke")
local Ui = require("bible-verse.core.ui")

local M = {
	show_input_ui = nil,
	show_popup_ui = nil,
	insert_input_ui = nil,
}

local function create_popup_io(conf, message_table) end

local function create_input_ui(conf, on_submit)
	local input_component = NuiInput(conf, {
		prompt = "", -- Use prompt as border text
		on_submit = on_submit,
	})

	-- Set exit behaviour
	input_component:map("n", "<Esc>", function()
		input_component:unmount()
	end, { noremap = true })
	input_component:on(NuiEvent.BufLeave, function()
		input_component:unmount()
	end, { once = true })

	return input_component
end

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
function M:query_and_show()
	if self.show_input_ui then
		-- unmount previous input UI
		self.show_input_ui:unmount()
	end

	-- Handle UI config
	local input_conf = vim.deepcopy(Config.options.ui.query_input)
	local popup_conf = vim.deepcopy(Config.options.ui.popup)
	local window_size = Utils.get_win_size(0)

	local popup_base_width = math.ceil(window_size.width * popup_opts.size.window_width_percentage)
	local popup_max_width = math.ceil(window_size.width * popup_opts.size.window_max_width_percentage)
	local popup_base_height = #message_table
	local popup_max_height = math.ceil(window_size.height * popup_opts.size.window_max_height_percentage)

	local border_text_len =
		math.max(string.len(input_conf.border.text.top or ""), string.len(input_conf.border.text.bottom or ""))

	input_conf.size.width = math.min(border_text_len, input_conf.size.max_width)

	-- On submit function
	local on_submit = function(input)
		if input and string.len(input) > 0 then
			local query_result = process_query(input, "plain")
			Ui:popup("BibleVerse", query_result)
		end
	end

	self.show_input_ui = create_input_ui(input_conf, function(input)
		on_submit(input)
		self.show_input_ui = nil
	end)

	self.show_input_ui:mount()
end

--- Prompt for user input and insert it below the cursor
function M:query_and_insert()
	if self.insert_input_ui then
		-- unmount previous input UI
		self.insert_input_ui:unmount()
	end

	-- Handle UI config
	local input_conf = vim.deepcopy(Config.options.ui.insert_input)
	local border_text_len =
		math.max(string.len(input_conf.border.text.top or ""), string.len(input_conf.border.text.bottom or ""))

	input_conf.size.width = math.min(border_text_len, input_conf.size.max_width)

	-- On submit function
	local on_submit = function(input)
		if input and string.len(input) > 0 then
			local query_result = process_query(input, Config.options.insert_format)
			local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
			vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, query_result)
		end
	end

	self.insert_input_ui = create_input_ui(input_conf, function(input)
		on_submit(input)
		self.insert_input_ui = nil
	end)

	self.insert_input_ui:mount()
end

return M
