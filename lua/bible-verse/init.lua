local formatter = require("bible-verse.formatter")
local health = require("bible-verse.health")
local diatheke_wrapper = require("bible-verse.diatheke_wrapper")
local ui = require("bible-verse.ui")

local M = {}

-- Config with defaults
M._conf = {
	default_behaviour = "query",
	paste_format = "markdown",

	diatheke = {
		translation = "ISV",
		locale = "en",
	},

	markdown = {
		separator = "---",
		omit_module_name = false,
	},

	plain = {
		header_delimiter = " ",
		omit_module_name = true,
	},
}

--- Helpers

---@package
--- Execute appropriate formatter based on strategy
---@param diatheke_result table result based on diatheke_wrapper.call
---@param formatter_type "markdown"|"plain" (string) type of formatter to be used
---@return table output table of individual lines of the output.
local function formatter_strategy(diatheke_result, formatter_type)
	if formatter_type == "markdown" then
		return formatter.markdown(
			diatheke_result,
			M._conf.diatheke.translation,
			M._conf.markdown.separator,
			M._conf.markdown.omit_module_name
		)
	elseif formatter_type == "plain" then
		return formatter.plain(
			diatheke_result,
			M._conf.diatheke.translation,
			M._conf.plain.omit_module_name,
			M._conf.plain.header_delimiter
		)
	else
		error("unsupported formatter strategy|formatter_type=" .. formatter_type)
	end
end

---@package
--- Process query within diatheke and return formatted output
---@param query string query to diatheke
---@param formatter_type "markdown"|"plain" (string) type of formatter to be used
---@return table output table of individual lines of the output.
local function process_query(query, formatter_type)
	local ok, res_or_err =
		pcall(diatheke_wrapper.call, M._conf.diatheke.translation, "plain", M._conf.diatheke.locale, query)
	if not ok then
		error("query returned error|err=" .. res_or_err)
	end
	return formatter_strategy(res_or_err, formatter_type)
end

--- Public functions

--- Equivalent of running :checkhealth bible-verse
local function hc()
	health.check()
end

--- Run query and show in on the screen
local function query()
	ui.input("BibleVerse Query", function(input)
		if input and string.len(input) > 0 then
			local query_result = process_query(input, "plain")
			ui.popup("BibleVerse", query_result)
		end
	end)
end

--- Run query and insert the query result at cursor
local function query_paste()
	ui.input("BibleVerse Query (Paste)", function(input)
		if input and string.len(input) > 0 then
			local query_result = process_query(input, M._conf.paste_format)
			local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
			vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, query_result)
		end
	end)
end

-- Export functions
M.health = hc
M.query = query
M.query_paste = query_paste

-- Accepted user commands
local user_mode_to_func = {
	["query"] = query,
	["paste"] = query_paste,
}
local other_user_action_to_func = {
	["health"] = hc,
}
local all_action_to_func = vim.tbl_deep_extend("error", user_mode_to_func, other_user_action_to_func)

--- Run setup for bible-verse, options and commands.
---@param opts? table options.
---@return table self reference of the module.
M.setup = function(opts)
	-- Configure options
	opts = opts or {}
	vim.tbl_deep_extend("force", M._conf, opts)

	-- Check that configuration does not break plugin setting
	assert(
		formatter.has_formatter(M._conf.paste_format),
		"unsupported formatter|formatter_type=" .. M._conf.paste_format
	)
	assert(
		user_mode_to_func[M._conf.default_behaviour] ~= nil,
		"unsupported default_behaviour|default_behaviour=" .. M._conf.default_behaviour
	)

	-- Configure commands
	vim.api.nvim_create_user_command("BibleVerse", M.BibleVerse, { desc = "Query bible verses", nargs = "?" })

	return M
end

-- Main entry point
M.BibleVerse = function(opts)
	local user_args = opts.args or ""

	local words = {}
	for word in user_args:gmatch("%w+") do
		table.insert(words, word)
	end

	-- Default behaviour
	if #words == 0 or all_action_to_func[words[1]] == nil then
		return user_mode_to_func[M._conf.default_behaviour]()
	end

	all_action_to_func[words[1]]()
end

return M
