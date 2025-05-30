-- Fix for SQL LSP connection error
-- Replace your nvim/lua/plugins/sql-formatter.lua with this:

return {
  -- Completely disable sqls LSP at the earliest possible moment
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.handlers = opts.handlers or {}
      -- Override sqls handler to do nothing
      opts.handlers.sqls = function() end
      return opts
    end,
  },

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

      -- Ensure sqls is completely disabled
      opts.servers.sqls = nil

      return opts
    end,
    init = function()
      -- Prevent sqls from auto-starting on SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          -- Stop any sqls clients that might have started
          local clients = vim.lsp.get_clients({ name = "sqls" })
          for _, client in ipairs(clients) do
            client.stop(true)
          end
        end,
      })
    end,
  },

  -- Additional explicit LSP disabling for SQL files
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.extras = opts.extras or {}
      -- Explicitly exclude any SQL-related extras
      local excluded = {
        "lazyvim.plugins.extras.lang.sql",
      }
      for _, extra in ipairs(excluded) do
        if vim.tbl_contains(opts.extras, extra) then
          table.remove(opts.extras, vim.tbl_index(opts.extras, extra))
        end
      end
      return opts
    end,
  },

  -- Auto-formatting on save
  {
    "stevearc/conform.nvim",
    init = function()
      -- Format SQL files on save
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
          -- Set cmdheight to 1 for SQL files to prevent Press ENTER prompts
          vim.opt.cmdheight = 1
          
          -- Filter out sqls LSP messages from statusline
          local original_notify = vim.notify
          vim.notify = function(msg, level, opts)
            if type(msg) == "string" and msg:match("sqls.*no database connection") then
              return -- Suppress this specific message
            end
            return original_notify(msg, level, opts)
          end
          
          -- Better indentation for SQL
          vim.opt_local.shiftwidth = 4
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.expandtab = true

          -- SQL-specific settings
          vim.opt_local.commentstring = "-- %s"
        end,
      })
      
      -- Reset cmdheight when leaving SQL files
      vim.api.nvim_create_autocmd("BufLeave", {
        pattern = { "*.sql" },
        callback = function()
          vim.opt.cmdheight = 0
        end,
      })
    end,
  },
}
