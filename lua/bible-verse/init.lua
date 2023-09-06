local M = {}

---@param opts? table
M.setup = function(opts)
	opts = opts or {}

	-- Run healthcheck first
	if not require("bible-verse.health").check({ checkhealth = false }) then
		vim.notify_once(
			"bible-verse.nvim: checkhealth failed. Please run :checkhealth bible-verse.",
			vim.log.levels.ERROR
		)
		return
	end

	local function load()
		require("bible-verse.config").setup(opts)
		require("bible-verse.commands").setup()
		require("bible-verse.formatter").setup()
		require("bible-verse.core").setup()
	end

	load()
end

---@param command? BibleVerseCmd
M.cmd = function(command)
	require("bible-verse.commands").cmd(command)
end

return M
