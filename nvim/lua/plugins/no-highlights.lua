-- Aggressive disable of all highlighting that could cause horizontal lines
return {
  -- Disable cursor line highlighting
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- Disable all highlight groups that could create horizontal lines
          vim.api.nvim_set_hl(0, "CursorLine", {})
          vim.api.nvim_set_hl(0, "CursorLineNr", {})
          vim.api.nvim_set_hl(0, "Visual", { bg = "#3c3836" })
          vim.api.nvim_set_hl(0, "IncSearch", {})
          vim.api.nvim_set_hl(0, "Search", { bg = "#504945" })
          vim.api.nvim_set_hl(0, "QuickFixLine", {})
          vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#504945" })
          
          -- Disable indent-related highlights
          vim.api.nvim_set_hl(0, "IndentBlanklineChar", {})
          vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", {})
          vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", {})
          vim.api.nvim_set_hl(0, "IblIndent", {})
          vim.api.nvim_set_hl(0, "IblScope", {})
          
          -- Disable scope-related highlights  
          vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {})
          vim.api.nvim_set_hl(0, "MiniIndentscopePrefix", {})
        end,
      })
      
      -- Apply immediately
      vim.api.nvim_set_hl(0, "CursorLine", {})
      vim.api.nvim_set_hl(0, "CursorLineNr", {})
      vim.api.nvim_set_hl(0, "Visual", { bg = "#3c3836" })
    end,
  },
}