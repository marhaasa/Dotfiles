return {
  "VonHeikemen/lsp-zero.nvim",
  config = function()
    local lsp = require("lsp-zero").setup({
      ensure_installed = {
        "tsserver",
        "pyright",
        "sqls",
      },
    })
  end,
}
