local Health = require("bible-verse.health")

local M = {}

--- Run setup for bible-verse, options and commands.
---@param opts? table options to override.
M.setup = function(opts)
	-- Run healthcheck first
	if not Health.check({ checkhealth = false }) then
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
	end

	load()
end

return M
