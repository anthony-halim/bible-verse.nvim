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

--- Checks if user input is required for the given query_opt.
---@param query_opt QueryOpts
---@return boolean require_user_input
function M._is_require_user_input(query_opt)
  local has_dynamic_verse = query_opt.random == true
  local has_user_query = query_opt.query and #query_opt.query > 0
  return not has_dynamic_verse and not has_user_query
end

--- Spawn input UI to prompt for user input and execute callback.
---@param base_input_config NuiInputOptions
---@param on_submit fun(input?: string): nil to execute on user submission
function M._prompt_user_input(base_input_config, on_submit)
  local input_conf = vim.deepcopy(base_input_config)
  local relative_size = Utils.get_relative_size(input_conf.relative)
  local border_text_len =
      math.max(string.len(input_conf.border.text.top or ""), string.len(input_conf.border.text.bottom or ""))

  input_conf.size.width = Utils.clamp(border_text_len, relative_size.width, input_conf.size.max_width)

  Ui:input(input_conf, on_submit)
end

--- Query the verse and return to the user.
-- Will query based on the following priority, sequantially from top to bottom:
-- - Random = true -> query random verse.
-- - Length of query > 0 -> query the given query.
---@param query_opt QueryOpts
---@return Verse[] result parsed output of the query
function M.query(query_opt)
  local verse_query = ""

  if query_opt.random then
    verse_query = VerseLib.random_verse()
  elseif #query_opt.query > 0 then
    verse_query = query_opt.query
  else
    error("invalid empty query")
  end

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
  ---@param res Verse[]
  local show_popup = function(res)
    local popup_conf = vim.deepcopy(Config.options.ui.popup)
    local popup_relative_size = Utils.get_relative_size(popup_conf.relative)

    local popup_width = math.ceil(
      math.min(
        popup_relative_size.width * popup_conf.size.max_width_percentage,
        popup_relative_size.width * popup_conf.size.width_percentage
      )
    )
    local popup_max_height = math.ceil(popup_relative_size.height * popup_conf.size.max_height_percentage)

    local formatted_query_result = Formatter.format(res, Config.options.query_format)
    local wrapped_query_result = Utils.wrap(formatted_query_result, popup_width)

    popup_conf.size.width = popup_width
    popup_conf.size.height = Utils.clamp(#wrapped_query_result, 1, popup_max_height)

    Ui:popup(popup_conf, wrapped_query_result, function(bufnr, first, last)
      Highlight.highlight_buf(bufnr, Config.options.highlighter[Config.options.query_format], first, last)
    end)
  end

  if not query_opt or M._is_require_user_input(query_opt) then
    ---@param input? string
    local on_submit = function(input)
      if input and string.len(input) > 0 then
        local query_result = M.query({ query = input, random = false })
        show_popup(query_result)
      end
    end
    M._prompt_user_input(Config.options.ui.query_input, on_submit)
  else
    local query_result = M.query(query_opt)
    show_popup(query_result)
  end
end

--- Query the verse and insert it below the cursor. If query is not provided, will prompt the user input.
---@param query_opt? QueryOpts
function M.query_and_insert(query_opt)
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

  ---@param res Verse[]
  local insert_to_buffer = function(res)
    local formatted_query_result = Formatter.format(res, Config.options.insert_format)
    local row, _ = unpack(vim.api.nvim_win_get_cursor(cur_window_handler))
    vim.api.nvim_buf_set_lines(cur_buf_handler, row - 1, row - 1, false, formatted_query_result)
  end

  if not query_opt or M._is_require_user_input(query_opt) then
    ---@param input? string
    local on_submit = function(input)
      if input and string.len(input) > 0 then
        local query_result = M.query({ query = input, random = false })
        insert_to_buffer(query_result)
      end
    end
    M._prompt_user_input(Config.options.ui.insert_input, on_submit)
  else
    local query_result = M.query(query_opt)
    insert_to_buffer(query_result)
  end
end

return M
