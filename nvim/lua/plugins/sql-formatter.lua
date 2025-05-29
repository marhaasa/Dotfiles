-- Fix for SQL LSP connection error
-- Replace your nvim/lua/plugins/sql-formatter.lua with this:

return {
  -- SQL Formatting with sqlformat
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      -- Use sqlformat for Visual Studio style formatting
      opts.formatters_by_ft.sql = { "sqlformat" }
      opts.formatters.sqlformat = {
        command = "sqlformat",
        args = {
          "--reindent",
          "--keywords",
          "upper",
          "--identifiers",
          "lower",
          "--indent_width",
          "4",
          "-",
        },
        stdin = true,
      }

      return opts
    end,
  },

  -- DISABLE SQL LSP to prevent connection errors
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Completely disable sqls LSP since we're using dbee for database operations
      opts.servers.sqls = false

      return opts
    end,
  },

  -- Auto-formatting on save
  {
    "stevearc/conform.nvim",
    init = function()
      -- Auto-format SQL files on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.sql",
        callback = function()
          require("conform").format({
            bufnr = vim.api.nvim_get_current_buf(),
            timeout_ms = 3000,
          })
        end,
      })

      -- Enhanced SQL file settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          local buf = vim.api.nvim_get_current_buf()

          -- Better indentation for SQL
          vim.opt_local.shiftwidth = 4
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.expandtab = true

          -- SQL-specific settings
          vim.opt_local.commentstring = "-- %s"
        end,
      })
    end,
  },
}
