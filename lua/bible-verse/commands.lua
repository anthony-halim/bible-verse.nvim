local Config = require("bible-verse.config")
local Core = require("bible-verse.core")
local Utils = require("bible-verse.utils")
local random_verse = require("bible-verse.utils.random-verse")

---@alias BibleVerseCmd "query"|"insert"|"random"
---@alias BibleVerseCmdFunc fun(): nil

local M = {}

local is_random = false
local function get_arguments()
	if is_random then
		return random_verse()
	end

	return nil
end

---@type table<BibleVerseCmd, BibleVerseCmdFunc>
M.commands = {}

--- Execute command by name
---@param cmd? string command name
function M.cmd(cmd)
	if cmd and string.find(cmd, "random") then
		is_random = true
	end

	local sanitised_cmd = Utils.sanitise_random(cmd or "")

	if cmd and M.commands[sanitised_cmd] then
		M.commands[sanitised_cmd]()
	else
		M.commands[Config.options.default_behaviour]()
	end

	is_random = false
end

function M.setup()
	M.commands = {
		query = function()
			Core.query_and_show(get_arguments())
		end,
		insert = function()
			Core.query_and_insert(get_arguments())
		end,
	}

	-- Check that config is sane
	assert(
		M.commands[Config.options.default_behaviour] ~= nil,
		"unsupported default_behaviour|default_behaviour=" .. Config.options.default_behaviour
	)

	-- Main func
	vim.api.nvim_create_user_command("BibleVerse", function(args)
		local command = vim.trim(args.args or "")
		M.cmd(command)
	end, {
		nargs = "*",
		desc = "Query bible verses",
		complete = function(_, line)
			-- Completed word
			if line:match("^%s*BibleVerse %w+ ") then
				return {}
			end

			-- Midword
			local prefix = line:match("^%s*BibleVerse (%w*)") or ""
			local arguments = vim.tbl_keys(M.commands)
			table.insert(arguments, "random")

			return vim.tbl_filter(function(key)
				return key:find(prefix) == 1
			end, arguments)
		end,
	})

	-- Sub funcs
	for name in pairs(M.commands) do
		local cmd = "BibleVerse" .. name:sub(1, 1):upper() .. name:sub(2)
		vim.api.nvim_create_user_command(cmd, function(args)
			local command = name .. " " .. vim.trim(args.args or "")
			M.cmd(command)
		end, { nargs = "?", desc = "BibleVerse " .. name })
	end
end

return M
