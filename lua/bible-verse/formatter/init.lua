local Config = require("bible-verse.config")

local M = {}

---@type table<string, function>
M.formatters = {}

function M.format(verses_table, formatter_type)
	if M.formatters[formatter_type] == nil then
		error("unsupported formatter|formatter_type=" .. formatter_type)
	end
	return M.formatters[formatter_type](verses_table)
end

function M.setup()
	M.formatters = {
		markdown = function(verses_table)
			return require("bible-verse.formatter.markdown").format(verses_table)
		end,
		plain = function(verses_table)
			return require("bible-verse.formatter.plain").format(verses_table)
		end,
	}

	-- Check that config is sane
	assert(
		M.formatters[Config.options.paste_format] ~= nil,
		"unsupported formatter|formatter_type=" .. Config.options.paste_format
	)
end

return M
