local Config = require("bible-verse.config")

local M = {}

---@type table<string, function>
M.commands = {}

--- Execute command by name
---@param cmd string command name
function M.cmd(cmd)
	if M.commands[cmd] then
		M.commands[cmd]()
	else
		M.commands[Config.options.default_behaviour]()
	end
end

function M.setup()
	M.commands = {
		query = function()
			require("bible-verse.core").query_and_show()
		end,
		paste = function()
			require("bible-verse.core").query_and_paste()
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
		nargs = "?",
		desc = "Query bible verses",
		complete = function(_, line)
			-- Completed word
			if line:match("^%s*BibleVerse %w+ ") then
				return {}
			end

			-- Midword
			local prefix = line:match("^%s*BibleVerse (%w*)") or ""
			return vim.tbl_filter(function(key)
				return key:find(prefix) == 1
			end, vim.tbl_keys(M.commands))
		end,
	})

	-- Sub funcs
	for name in pairs(M.commands) do
		local cmd = "BibleVerse" .. name:sub(1, 1):upper() .. name:sub(2)
		vim.api.nvim_create_user_command(cmd, function()
			M.cmd(name)
		end, { desc = "BibleVerse " .. name })
	end
end

return M
