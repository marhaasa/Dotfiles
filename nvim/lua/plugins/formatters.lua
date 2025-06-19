return {
  -- Disable sqls LSP to prevent connection errors
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.handlers = opts.handlers or {}
      opts.handlers.sqls = function() end -- Disable sqls handler
      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.sqls = nil -- Disable sqls server
      return opts
    end,
  },

  -- Main formatting configuration with conform.nvim
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      -- SQL formatting with sqlformat
      opts.formatters_by_ft.sql = { "sqlformat" }
      opts.formatters.sqlformat = {
        command = "sql-formatter",
        args = {
          "--language", "tsql",
          "-c", vim.fn.stdpath("config") .. "/sql-formatter.json",
        },
        stdin = true,
        timeout_ms = 15000, -- Increase timeout to 15 seconds for large files
        condition = function(self, ctx)
          -- Add some debugging
          local file_size = vim.fn.getfsize(ctx.filename)
          if file_size > 100000 then -- 100KB
            vim.notify("Large SQL file detected (" .. file_size .. " bytes), formatting may take longer", vim.log.levels.INFO)
          end
          return true
        end,
      }

      -- Python formatting with black
      opts.formatters_by_ft.python = { "black" }

      return opts
    end,

    init = function()
      -- Override LazyVim's format-on-save for SQL files with longer timeout
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.sql" },
        callback = function(args)
          require("conform").format({
            bufnr = args.buf,
            timeout_ms = 15000,
            lsp_fallback = false,
          })
        end,
      })

      -- Manual formatting keymaps for SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.keymap.set("n", "<leader>fmt", function()
            require("conform").format({
              bufnr = vim.api.nvim_get_current_buf(),
              timeout_ms = 15000,
            })
          end, { desc = "Format SQL", buffer = true })
          
          vim.keymap.set("n", "<leader>fma", function()
            require("conform").format({
              bufnr = vim.api.nvim_get_current_buf(),
              timeout_ms = 15000,
            })
          end, { desc = "Format and align SQL", buffer = true })

          -- Debug formatting command
          vim.keymap.set("n", "<leader>fmd", function()
            local file_path = vim.fn.expand("%:p")
            vim.notify("Attempting to format: " .. file_path, vim.log.levels.INFO)
            require("conform").format({
              bufnr = vim.api.nvim_get_current_buf(),
              timeout_ms = 15000,
              lsp_fallback = false,
            }, function(err)
              if err then
                vim.notify("Format error: " .. vim.inspect(err), vim.log.levels.ERROR)
              else
                vim.notify("Format completed successfully", vim.log.levels.INFO)
              end
            end)
          end, { desc = "Debug format SQL", buffer = true })

          -- SQL-specific settings
          vim.opt_local.shiftwidth = 4
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.expandtab = true
          vim.opt_local.commentstring = "-- %s"
        end,
      })

      -- Manual formatting keymaps for Python files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.keymap.set("n", "<leader>fmt", function()
            require("conform").format({
              bufnr = vim.api.nvim_get_current_buf(),
              timeout_ms = 3000,
            })
          end, { desc = "Format Python", buffer = true })

          -- Python-specific settings
          vim.opt_local.shiftwidth = 4
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.expandtab = true
        end,
      })
    end,
  },
}