local Config = require("bible-verse.config")
local Utils = require("bible-verse.utils")

local M = {}

---@param bufnr integer
---@param conf? table<string, _BibleVerseHLSettings>
---@param first? integer
---@param last? integer
function M.highlight_buf(bufnr, conf, first, last)
  if conf == nil or not Utils.is_valid_buf(bufnr, Config.options.exclude_buffer_filetypes) then
    return
  end

  first = first or 0
  last = last or vim.api.nvim_buf_line_count(bufnr)

  vim.api.nvim_buf_clear_namespace(bufnr, Config.ns, first, last)

  local lines = vim.api.nvim_buf_get_lines(bufnr, first, last, false)
  local replace_offset = 0

  for l, line in ipairs(lines) do
    replace_offset = 0

    for _, settings in pairs(conf) do
      line:gsub(settings.pattern, function(pattern_start_idx, word, pattern_end_idx)
        local start_replace_from = pattern_start_idx - 1 + replace_offset
        local start_replace_to = pattern_end_idx - 1 + replace_offset

        vim.api.nvim_buf_set_text(bufnr, l - 1, start_replace_from, l - 1, start_replace_to, { word })
        vim.api.nvim_buf_add_highlight(
          bufnr,
          Config.ns,
          settings.hlgroup,
          l - 1,
          start_replace_from,
          start_replace_from + #word
        )

        -- On every replacement, we need to offset to ensure match indexes are shifted
        -- along with the replacement step.
        --
        -- e.g.
        -- 'I am b{first} match & b{second} match in the line'
        -- -> First match: pattern_start_idx: 6, word: 'first', pattern_end_idx: 13
        -- -> Second match: pattern_start_idx: 23, wod: 'second', pattern_end_idx: 31
        --
        -- After first replacement on 'b{first}' with 'first', line is now:
        -- 'I am first match & b{second} match in the line'
        -- -> First match: pattern_start_idx: 6, word: 'first', pattern_end_idx: 13
        -- -> Second match: pattern_start_idx: 23, word: 'second', pattern_end_idx: 31
        --
        -- The second match match indexes are not updated and will point to the wrong index.
        -- The offset required is defined as:
        --
        -- accumulated_offset = previous_offset + length difference of matched pattern and replaced word
        replace_offset = replace_offset + (#word - (pattern_end_idx - pattern_start_idx))
      end)
    end
  end
end

return M
