return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")

    -- Ensure this doesn't conflict with lsp-zero
    lspconfig.tsserver.setup({})
    lspconfig.pyright.setup({})
    lspconfig.sqls.setup({
      on_attach = function(client, bufnr)
        -- Disable formatting for sqls
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        sqls = {
          format = {
            enable = false, -- Disable formatting
          },
        },
      },
    })
  end,
}
