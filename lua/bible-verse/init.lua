local Commands = require("bible-verse.commands")

local M = {}

---@param opts BibleVerseConfig
M.setup = function(opts)
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

-- Public APIs
M.cmd = function()
	Commands.cmd("")
end
M.query = function()
	Commands.cmd("query")
end
M.insert = function()
	Commands.cmd("insert")
end

return M
