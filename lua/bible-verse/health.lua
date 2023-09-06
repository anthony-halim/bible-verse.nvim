local Utils = require("bible-verse.utils")

local M = {}

--- Report result
---@param checkhealth boolean to trigger actual checkhealth
---@param result boolean result of test
---@param severity "warn"|"error" severity if result fails
---@param success_msg string success message
---@param err_msg string error message
function M.report(checkhealth, result, severity, success_msg, err_msg)
	local res_severity = result and "ok" or severity
	local res_message = result and success_msg or err_msg
	if checkhealth then
		vim.health[res_severity](res_message)
	end
	return result
end

---@param opts? { checkhealth?: boolean }
function M.check(opts)
	opts = opts or {}
	opts.checkhealth = opts.checkhealth == nil and true or opts.checkhealth

	local neovim_version_ok = M.report(
		opts.checkhealth,
		vim.fn.has("nvim-0.9.1") == 1,
		"error",
		"Neovim >= 0.9.1",
		"BibleVerse needs Neovim >= 0.9.1"
	)

	local diatheke_ok = M.report(
		opts.checkhealth,
		Utils.command_exists("diatheke"),
		"error",
		"diatheke is installed",
		"diatheke is not installed"
	)

	local nui_ok = M.report(
		opts.checkhealth,
		Utils.module_exists("nui.popup")
			and Utils.module_exists("nui.input")
			and Utils.module_exists("nui.utils.autocmd"),
		"error",
		"nui.nvim is installed",
		"nui.nvim is not installed"
	)

	local overall_healthy = neovim_version_ok and diatheke_ok and nui_ok

	return overall_healthy
end

return M
