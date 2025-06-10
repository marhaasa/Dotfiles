-- Minimal statusline configuration
-- Shows only essential information: mode, file, and position

local M = {}

-- Mode mappings with colors
local modes = {
  ["n"] = { "NORMAL", "StatusNormal" },
  ["no"] = { "N-PENDING", "StatusNormal" },
  ["i"] = { "INSERT", "StatusInsert" },
  ["ic"] = { "INSERT", "StatusInsert" },
  ["t"] = { "TERMINAL", "StatusTerminal" },
  ["v"] = { "VISUAL", "StatusVisual" },
  ["V"] = { "V-LINE", "StatusVisual" },
  [""] = { "V-BLOCK", "StatusVisual" },
  ["R"] = { "REPLACE", "StatusReplace" },
  ["Rv"] = { "V-REPLACE", "StatusReplace" },
  ["s"] = { "SELECT", "StatusSelect" },
  ["S"] = { "S-LINE", "StatusSelect" },
  [""] = { "S-BLOCK", "StatusSelect" },
  ["c"] = { "COMMAND", "StatusCommand" },
  ["cv"] = { "COMMAND", "StatusCommand" },
  ["ce"] = { "COMMAND", "StatusCommand" },
  ["r"] = { "PROMPT", "StatusCommand" },
  ["rm"] = { "MORE", "StatusCommand" },
  ["r?"] = { "CONFIRM", "StatusCommand" },
  ["!"] = { "SHELL", "StatusCommand" },
}

-- Get current mode
function M.mode()
  local mode = vim.fn.mode()
  local mode_info = modes[mode] or { "UNKNOWN", "StatusNormal" }
  return string.format("%%#%s# %s %%*", mode_info[2], mode_info[1])
end

-- Get file info
function M.file_info()
  local file = vim.fn.expand("%:t")
  if file == "" then
    file = "[No Name]"
  end
  
  local modified = vim.bo.modified and " ●" or ""
  local readonly = vim.bo.readonly and " " or ""
  
  return string.format("%%#StatusLineNC# %s%s%s%%*", file, modified, readonly)
end

-- Get position info
function M.position()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local total = vim.fn.line("$")
  return string.format("%%#StatusLineNC# %d:%d/%d %%*", line, col, total)
end

-- Build complete statusline
function M.build_statusline()
  return table.concat({
    M.mode(),
    M.file_info(),
    "%#StatusLineNC#%=", -- Right align with subtle background
    M.position(),
  })
end

-- Set up statusline
function M.setup()
  -- Define highlight groups for different modes (subtle backgrounds)
  vim.api.nvim_set_hl(0, "StatusNormal", { fg = "#fe8019", bg = "#3c3836", bold = true })    -- Orange text, dark bg
  vim.api.nvim_set_hl(0, "StatusInsert", { fg = "#b8bb26", bg = "#3c3836", bold = true })    -- Green text, dark bg
  vim.api.nvim_set_hl(0, "StatusVisual", { fg = "#83a598", bg = "#3c3836", bold = true })    -- Blue text, dark bg
  vim.api.nvim_set_hl(0, "StatusReplace", { fg = "#fb4934", bg = "#3c3836", bold = true })   -- Red text, dark bg
  vim.api.nvim_set_hl(0, "StatusCommand", { fg = "#d3869b", bg = "#3c3836", bold = true })   -- Purple text, dark bg
  vim.api.nvim_set_hl(0, "StatusSelect", { fg = "#fabd2f", bg = "#3c3836", bold = true })    -- Yellow text, dark bg
  vim.api.nvim_set_hl(0, "StatusTerminal", { fg = "#8ec07c", bg = "#3c3836", bold = true })  -- Aqua text, dark bg
  
  -- Very subtle background for filename and position
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#a89984", bg = "#282828" })  -- Gruvbox dim text on very dark bg
  
  -- Set the statusline
  vim.opt.statusline = "%!v:lua.require('config.statusline').build_statusline()"
  
  -- Enable statusline (override the laststatus = 0 setting)
  vim.opt.laststatus = 2
  
end

return M