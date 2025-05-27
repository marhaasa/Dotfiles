-- Snacks.nvim config - only statuscolumn and dashboard, disable highlighting features
return {
  "folke/snacks.nvim",
  opts = {
    -- Essential functionality
    statuscolumn = { enabled = true }, -- Required by LazyVim
    dashboard = { enabled = true },     -- Entry screen
    
    -- Disable features that might cause horizontal highlights
    scroll = { enabled = false },       -- This might cause highlighting
    words = { enabled = false },        -- Word highlighting
    animate = { enabled = false },      -- Animation effects
    indent = { enabled = false },       -- Indent highlighting
    scope = { enabled = false },        -- Scope highlighting
    
    -- Other features (keep disabled)
    notifier = { enabled = false },
    quickfile = { enabled = false },
    zen = { enabled = false },
    bigfile = { enabled = false },
    bufdelete = { enabled = false },
    debug = { enabled = false },
    git = { enabled = false },
    gitbrowse = { enabled = false },
    lazygit = { enabled = false },
    picker = { enabled = false },
    profiler = { enabled = false },
    rename = { enabled = false },
    scratch = { enabled = false },
    terminal = { enabled = false },
    toggle = { enabled = false },
  },
}