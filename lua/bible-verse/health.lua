local M = {}

---@param cmd string
function M.command_exists(cmd)
	return vim.fn.executable(cmd) ~= 0
end

---@param mod string
function M.module_exists(mod)
	return pcall(_G.require, mod) == true
end

---comment
---@param checkhealth boolean
---@param result boolean
---@param severity "warn"|"error"
---@param success_msg string
---@param err_msg string
function M._report(checkhealth, result, severity, success_msg, err_msg)
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

	local neovim_version_ok = M._report(
		opts.checkhealth,
		vim.fn.has("nvim-0.9.0") == 1,
		"error",
		"Neovim >= 0.9.0",
		"BibleVerse needs Neovim >= 0.9.0"
	)

	local diatheke_ok = M._report(
		opts.checkhealth,
		M.command_exists("diatheke"),
		"error",
		"diatheke is installed",
		"diatheke is not installed"
	)

	local nui_ok = M._report(
		opts.checkhealth,
		M.module_exists("nui.popup") and M.module_exists("nui.input") and M.module_exists("nui.utils.autocmd"),
		"error",
		"nui.nvim is installed",
		"nui.nvim is not installed"
	)

	local overall_healthy = neovim_version_ok and diatheke_ok and nui_ok

	return overall_healthy
end

return M
