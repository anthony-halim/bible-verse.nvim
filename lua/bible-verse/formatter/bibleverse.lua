local Config = require("bible-verse.config")
local FormatterCommon = require("bible-verse.formatter.common")

local M = {}

--- Formats parsed diatheke output and format it in Markdown style.
---@param verses_table Verse[] parsed diatheke output.
---@return string[] output individual lines of the output.
function M.format(verses_table)
  local res = {}
  local sorted_bible_chapter = FormatterCommon.organise_by_sorted_bible_chapter(verses_table)
  local sorted_bible_chapter_len = #sorted_bible_chapter
  local use_separator = string.len(Config.options.formatter.bibleverse.separator) ~= 0

  for idx, sorted_chap in ipairs(sorted_bible_chapter) do
    table.insert(res, string.format("bc{%s}", sorted_chap.name))
    table.insert(res, "")

    local chapter_res = {}
    for v_idx, verse in ipairs(sorted_chap.verses) do
      if v_idx > 1 and verse.verse_prefix_newline then
        table.insert(res, table.concat(chapter_res))
        table.insert(res, "")
        chapter_res = {}
      end
      table.insert(
        chapter_res,
        string.format("vn{%s}%s ", FormatterCommon.to_sup_num(verse.verse_number), verse.verse)
      )
    end
    table.insert(res, table.concat(chapter_res))

    if idx < sorted_bible_chapter_len then
      table.insert(res, "")
      if use_separator then
        table.insert(res, string.format("sp{%s}", Config.options.formatter.bibleverse.separator))
      end
      table.insert(res, "")
    end
  end
  if not Config.options.formatter.bibleverse.omit_translation_footnote then
    table.insert(res, "")
    table.insert(res, string.format("t{%s}", Config.options.diatheke.translation))
  end

  return res
end

return M
