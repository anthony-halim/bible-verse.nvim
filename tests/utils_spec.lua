---@diagnostic disable: undefined-global

local Utils = require("bible-verse.utils")

describe("Utils.wrap:", function()
	it("no wrapping on long words", function()
		local input = { "this isaverylongstringwithoutwhitespacesandshouldnotbewrapped" }
		local expected_output = { "this", "isaverylongstringwithoutwhitespacesandshouldnotbewrapped" }
		local limit = 5

		assert.same(expected_output, Utils.wrap(input, limit))
	end)

	it("handle case with no whitespace", function()
		local input = { "thisisaverylongstringwithoutwhitespacesandshouldnotbewrapped" }
		local expected_output = { "thisisaverylongstringwithoutwhitespacesandshouldnotbewrapped" }
		local limit = 5

		assert.same(expected_output, Utils.wrap(input, limit))
	end)

	it("wrap before hitting limit", function()
		local input = { "this should break before reaching limit" }
		local limit = 10
		local output = Utils.wrap(input, limit)

		for _, o in ipairs(output) do
			assert.is_true(o:len() <= limit)
		end
	end)
end)

--- TODO: Test utils.is_valid_buf exclusion
--- 1. invalid buffer
--- 2. excluded buffer
