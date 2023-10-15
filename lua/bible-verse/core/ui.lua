local NuiInput = require("nui.input")
local NuiPopup = require("nui.popup")
local NuiEvent = require("nui.utils.autocmd").event

local M = {
  input_ui = nil,
  popup_ui = nil,
}

---Take user input and call on_submit on submission.
---@param config NuiInputOptions
---@param on_submit fun(input?: string): nil to execute on user submission
function M:input(config, on_submit)
  local cleanup = function()
    if self.input_ui then
      self.input_ui:unmount()
      self.input_ui = nil
    end
  end

  -- Cleanup previous instance, if any
  cleanup()

  self.input_ui = NuiInput(config, {
    prompt = "", -- Use prompt as border text
    on_submit = function(input)
      on_submit(input)
      cleanup()
    end,
  })

  -- Set exit behaviour
  self.input_ui:map("n", "<Esc>", function()
    cleanup()
  end, { noremap = true })
  self.input_ui:on(NuiEvent.BufLeave, function()
    cleanup()
  end, { once = true })

  self.input_ui:mount()
end

---Show message as a pop up window.
---@param config NuiPopupOptions
---@param message_table string[] table of individual lines to be shown.
---@param highlight_fn? fun(bufnr: integer, first?: integer, last?: integer): nil buffer highlighter.
function M:popup(config, message_table, highlight_fn)
  local cleanup = function()
    if self.popup_ui then
      self.popup_ui:unmount()
      self.popup_ui = nil
    end
  end

  -- Cleanup previous instance, if any
  cleanup()

  self.popup_ui = NuiPopup(config)

  -- Set exit behaviour
  self.popup_ui:map("n", "<Esc>", function()
    cleanup()
  end, { noremap = true })
  self.popup_ui:map("n", "q", function()
    cleanup()
  end, { noremap = true })
  self.popup_ui:on(NuiEvent.BufLeave, function()
    cleanup()
  end, { once = true })

  vim.api.nvim_buf_set_lines(self.popup_ui.bufnr, 0, 0, false, message_table)

  if highlight_fn then
    -- NOTE: Once mounted, the popup may not be modifiable. We will not be able
    -- to add highlight. Hence we highlight entire buffer before mounting.
    -- PERF: Should be fine since we limit the buffer count to 1 (popup is kinda 'singleton')
    local first = 0
    local last = vim.api.nvim_buf_line_count(self.popup_ui.bufnr)
    highlight_fn(self.popup_ui.bufnr, first, last)
  end

  self.popup_ui:mount()
end

return M
