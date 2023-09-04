local Config = require("bible-verse.config")
local Utils = require("bible-verse.utils")

local M = {
	---@type table<integer, boolean>
	win_handlers = {},
}

---@param bufnr integer
---@param conf? table<string, _BibleVerseHLSettings>
---@param first? integer
---@param last? integer
function M.highlight_buf(bufnr, conf, first, last)
	if conf == nil or not Utils.is_valid_buf(bufnr, Config.options.exclude_buffer_filetypes) then
		return
	end

	first = first or 0
	last = last or vim.api.nvim_buf_line_count(bufnr)

	vim.api.nvim_buf_clear_namespace(bufnr, Config.ns, first, last)

	local lines = vim.api.nvim_buf_get_lines(bufnr, first, last, false)
	for l, line in ipairs(lines) do
		for _, settings in pairs(conf) do
			line:gsub(settings.pattern, function(pattern_start_idx, word, pattern_end_idx)
				vim.api.nvim_buf_set_text(bufnr, l - 1, pattern_start_idx - 1, l - 1, pattern_end_idx - 1, { word })
				vim.api.nvim_buf_add_highlight(
					bufnr,
					Config.ns,
					"bibleversehl",
					l - 1,
					pattern_start_idx - 1,
					pattern_start_idx + #word - 1
				)
			end)
		end
	end
end

return M
