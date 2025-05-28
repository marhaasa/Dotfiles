return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("gruvbox").setup({
      contrast = "hard",
      overrides = {
        Title = { link = "GruvboxOrangeBold" },
      },
    })
    vim.cmd.colorscheme("gruvbox")
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
  end,
}
