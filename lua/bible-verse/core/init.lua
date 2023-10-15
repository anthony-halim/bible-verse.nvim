local Config = require("bible-verse.config")
local Formatter = require("bible-verse.formatter")
local Utils = require("bible-verse.utils")
local Diatheke = require("bible-verse.core.diatheke")
local VerseLib = require("bible-verse.core.verse")
local Ui = require("bible-verse.core.ui")
local Highlight = require("bible-verse.core.highlight")

local M = {}

function M.setup()
  -- Check that config is sane
  assert(
    Config.options.diatheke.translation and string.len(Config.options.diatheke.translation) > 0,
    "missing configuration|diatheke.translation"
  )
end

---@alias QueryOpts { query: string, random: boolean }

--- Query the verse and return to the user.
---@param query_opt QueryOpts
---@return Verse[] result parsed output of the query
function M.query(query_opt)
  local verse_query = query_opt.random and VerseLib.random_verse() or query_opt.query
  local ok, res_or_err =
    pcall(Diatheke.call, Config.options.diatheke.translation, "plain", Config.options.diatheke.locale, verse_query)
  if not ok then
    error("query returned error|err=" .. res_or_err)
  end
  return res_or_err
end

--- Query the verse and show it back to the screen. If query is not provided, will prompt the user input.
---@param query_opt? QueryOpts
function M.query_and_show(query_opt)
  query_opt = query_opt or { query = "", random = false }

  -- On submit function
  local on_submit = function(input)
    if input and string.len(input) > 0 then
      local popup_conf = vim.deepcopy(Config.options.ui.popup)
      local popup_relative_size = Utils.get_relative_size(popup_conf.relative)

      local popup_width = math.ceil(
        math.min(
          popup_relative_size.width * popup_conf.size.max_width_percentage,
          popup_relative_size.width * popup_conf.size.width_percentage
        )
      )
      local popup_max_height = math.ceil(popup_relative_size.height * popup_conf.size.max_height_percentage)

      local query_result = M.query({ query = input, random = false })
      local formatted_query_result = Formatter.format(query_result, Config.options.query_format)
      local wrapped_query_result = Utils.wrap(formatted_query_result, popup_width)

      popup_conf.size.width = popup_width
      popup_conf.size.height = Utils.clamp(#wrapped_query_result, 1, popup_max_height)

      Ui:popup(popup_conf, wrapped_query_result, function(bufnr, first, last)
        Highlight.highlight_buf(bufnr, Config.options.highlighter[Config.options.query_format], first, last)
      end)
    end
  end

  if query_opt.random then
    -- Query random verse
    on_submit(VerseLib.random_verse())
  elseif query_opt.query and #query_opt.query > 0 then
    -- Handle user query directly
    on_submit(query_opt.query)
  else
    -- Prompt for user input then query
    local input_conf = vim.deepcopy(Config.options.ui.query_input)
    local relative_size = Utils.get_relative_size(input_conf.relative)
    local border_text_len =
      math.max(string.len(input_conf.border.text.top or ""), string.len(input_conf.border.text.bottom or ""))

    input_conf.size.width = Utils.clamp(border_text_len, relative_size.width, input_conf.size.max_width)

    Ui:input(input_conf, on_submit)
  end
end

--- Query the verse and insert it below the cursor. If query is not provided, will prompt the user input.
---@param query_opt? QueryOpts
function M.query_and_insert(query_opt)
  query_opt = query_opt or { query = "", random = false }

  local cur_window_handler = vim.api.nvim_get_current_win()
  if not Utils.is_valid_win(cur_window_handler) then
    vim.notify("BibleVerse: invalid window to do insertion.", vim.log.levels.WARN)
    return
  end

  local cur_buf_handler = vim.api.nvim_win_get_buf(cur_window_handler)
  if not Utils.is_valid_buf(cur_buf_handler, Config.options.exclude_buffer_filetypes) then
    vim.notify(
      "BibleVerse: invalid buffer to do insertion. Did you try to insert on wrong buffer?",
      vim.log.levels.WARN
    )
    return
  end

  -- On submit function
  local on_submit = function(input)
    if input and string.len(input) > 0 then
      local query_result = M.query({ query = input, random = false })
      local formatted_query_result = Formatter.format(query_result, Config.options.insert_format)
      local row, _ = unpack(vim.api.nvim_win_get_cursor(cur_window_handler))

      vim.api.nvim_buf_set_lines(cur_buf_handler, row - 1, row - 1, false, formatted_query_result)
    end
  end

  if query_opt.random then
    -- Query random verse
    on_submit(VerseLib.random_verse())
  elseif query_opt.query and #query_opt.query > 0 then
    -- Handle user query directly
    on_submit(query_opt.query)
  else
    -- Prompt for user input then query
    local input_conf = vim.deepcopy(Config.options.ui.insert_input)
    local relative_size = Utils.get_relative_size(input_conf.relative)
    local border_text_len =
      math.max(string.len(input_conf.border.text.top or ""), string.len(input_conf.border.text.bottom or ""))

    input_conf.size.width = Utils.clamp(border_text_len, relative_size.width, input_conf.size.max_width)

    Ui:input(input_conf, on_submit)
  end
end

return M
