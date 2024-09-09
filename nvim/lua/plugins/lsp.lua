return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.tsserver.setup({})
      lspconfig.pyright.setup({})
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "mattiasmts/cmp-dbee",
    },
    config = function()
      local import_cmp, cmp = pcall(require, "cmp")
      if not import_cmp then
        return
      end

      local import_luasnip, luasnip = pcall(require, "luasnip")
      if not import_luasnip then
        return
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "cmp-dbee" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.sql_formatter.with({
            extra_args = {
              "--config",
              vim.fn.expand("~/.config/.sql-formatter.json"),
            },
          }), -- Changed to sql-formatter
          null_ls.builtins.formatting.black, -- Python
          null_ls.builtins.formatting.prettier, -- JavaScript/TypeScript
          null_ls.builtins.formatting.stylua, -- Lua
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.cmd([[
              augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })
              augroup END
            ]])
          end
        end,
      })
    end,
  },
}
