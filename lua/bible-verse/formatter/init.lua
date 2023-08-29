local Config = require("bible-verse.config")

---@alias FormatterType "plain"|"markdown"|"nerd"
---@alias FormatFunc fun(verses_table: DiathekeVerse[]): string[]

local M = {}

---@type table<FormatterType, FormatFunc>
M.formatters = {}

---Format based on given formatter type
---@param verses_table DiathekeVerse[] pased diatheke output
---@param formatter_type FormatterType type of formatter
---@return string[] output individual lines of the output
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
		nerd = function(verses_table)
			return require("bible-verse.formatter.nerd").format(verses_table)
		end,
		plain = function(verses_table)
			return require("bible-verse.formatter.plain").format(verses_table)
		end,
	}

	-- Check that config is sane
	assert(
		M.formatters[Config.options.insert_format] ~= nil,
		"unsupported formatter|formatter_type=" .. Config.options.insert_format
	)
end

return M
