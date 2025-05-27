return {
  { "echasnovski/mini.pairs", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  
  -- Disable ALL mini.nvim modules to prevent conflicts
  { "echasnovski/mini.nvim", enabled = false },
  
  -- Disable LazyVim plugins that cause horizontal highlights
  { "echasnovski/mini.indentscope", enabled = false },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "echasnovski/mini.hipatterns", enabled = false },
  { "RRethy/vim-illuminate", enabled = false },
  { "folke/flash.nvim", enabled = false },
  { "echasnovski/mini.cursorword", enabled = false },
  
  -- Disable statusline plugins but keep snacks for essential functions
  { "nvim-lualine/lualine.nvim", enabled = false },
  
  -- Keep mini.starter disabled since we're using minimal snacks
  { "echasnovski/mini.starter", enabled = false },
}
