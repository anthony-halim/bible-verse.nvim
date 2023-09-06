---@diagnostic disable: undefined-global

local Diatheke = require("bible-verse.core.diatheke")

local expected_output = {
	{
		book = "John",
		chapter = "1",
		verse_number = "13",
		verse_prefix_newline = false,
		verse = "Which were born, not of blood, nor of the will of the flesh, nor of the will of man, but of God.",
		verse_suffix_newline = false,
	},
	{
		book = "John",
		chapter = "1",
		verse_number = "14",
		verse_prefix_newline = false,
		verse = "And the Word was made flesh, and dwelt among us, (and we beheld his glory, the glory as of the only begotten of the Father,) full of grace and truth.",
		verse_suffix_newline = false,
	},
	{
		book = "John",
		chapter = "1",
		verse_number = "15",
		verse_prefix_newline = true,
		verse = "John bare witness of him, and cried, saying, This was he of whom I spake, He that cometh after me is preferred before me: for he was before me.",
		verse_suffix_newline = false,
	},
}

describe("Diatheke:", function()
	it("Parse verse", function()
		local test_case_idx = 1
		assert.same(
			{ expected_output[test_case_idx] },
			Diatheke.call(
				"KJV",
				"plain",
				"en",
				string.format(
					"%s %s:%s",
					expected_output[test_case_idx].book,
					expected_output[test_case_idx].chapter,
					expected_output[test_case_idx].verse_number
				)
			)
		)
	end)

	it("Parse verse with newline prefix", function()
		local test_case_idx = 3
		assert.same(
			{ expected_output[test_case_idx] },
			Diatheke.call(
				"KJV",
				"plain",
				"en",
				string.format(
					"%s %s:%s",
					expected_output[test_case_idx].book,
					expected_output[test_case_idx].chapter,
					expected_output[test_case_idx].verse_number
				)
			)
		)
	end)

	it("Parse multi-verse with newline prefix", function()
		assert.same(
			expected_output,
			Diatheke.call(
				"KJV",
				"plain",
				"en",
				string.format(
					"%s %s:%s-%s",
					expected_output[1].book,
					expected_output[1].chapter,
					expected_output[1].verse_number,
					expected_output[#expected_output].verse_number
				)
			)
		)
	end)
end)
