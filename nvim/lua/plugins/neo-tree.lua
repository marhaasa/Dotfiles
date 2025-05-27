return {
  "nvim-neo-tree/neo-tree.nvim",
  requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        diagnostics = {
          enable = false, -- Disable diagnostics
        },
      },
    })
  end,
}
