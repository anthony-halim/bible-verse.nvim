---@alias _NuiBorderStyle "'double'"|"'none'"|"'rounded'"|"'shadow'"|"'single'"|"'solid'"

---@alias _NuiBorderPadding {top:number, right:number, bottom:number, left:number}

---@class _NuiBorder
---@field padding? _NuiBorderPadding|number[]
---@field style? _NuiBorderStyle
---@field text? { top: string, top_align: "'left'" | "'center'" | "'right'", bottom: string, bottom_align: "'left'" | "'center'" | "'right'" }

---@class _NuiBaseOptions
---@field position? number|string|{ row: number|string, col: number|string}
---@field timeout? number
---@field buf_options? vim.bo
---@field win_options? vim.wo
---@field focusable boolean
---@field enter? boolean
---@field close? {events?:string[], keys?:string[]}
---@field relative? "'cursor'"|"'editor'"|"'win'"
---@field border? _NuiBorder
---@field zindex? number

---@class _NuiPopUpSize
---@field width? number|string
---@field height? number|string
---@field width_percentage? number -- custom attribute
---@field max_width_percentage? number -- custom attribute
---@field max_height_percentage? number -- custom attribute
--
---@class _NuiPopupOptions: _NuiBaseOptions
---@field size? _NuiPopUpSize

---@class _NuiInputSize
---@field width? number|string
---@field height? number|string
---@field max_width number -- custom attribute

---@class _NuiInputOptions: _NuiBaseOptions
---@field size? _NuiInputSize

---@class NuiPopupOptions: _NuiPopupOptions

---@class NuiInputOptions: _NuiInputOptions
