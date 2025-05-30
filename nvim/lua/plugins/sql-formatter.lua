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

  -- SQL Formatting with sqlformat - for manual use only
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      -- Define the formatter for manual use only
      opts.formatters_by_ft.sql = { "sqlformat" }
      opts.formatters.sqlformat = {
        command = "sql-formatter",
        args = {
          "--language", "tsql",
          "--config", vim.fn.stdpath("config") .. "/sql-formatter.json",
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

  -- Manual formatting with keybinding
  {
    "stevearc/conform.nvim",
    init = function()
      -- Manual SQL formatting with <leader>f
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.keymap.set("n", "<leader>f", function()
            require("conform").format({
              bufnr = vim.api.nvim_get_current_buf(),
              timeout_ms = 3000,
            })
          end, { desc = "Format SQL", buffer = true })
          
          -- Add column alignment function
          vim.keymap.set("n", "<leader>fa", function()
            -- First format with sql-formatter
            require("conform").format({
              bufnr = vim.api.nvim_get_current_buf(),
              timeout_ms = 3000,
            })
            
            -- Then align columns in CREATE TABLE statements
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local aligned_lines = {}
            local in_table = false
            local column_lines = {}
            
            for i, line in ipairs(lines) do
              if line:match("CREATE TABLE") then
                in_table = true
                table.insert(aligned_lines, line)
              elseif in_table and line:match("^%s*%)") then
                -- Align collected column lines
                if #column_lines > 0 then
                  local max_name_len = 0
                  local max_type_len = 0
                  
                  -- Find max lengths - handle both bracketed and non-bracketed names
                  for _, col_line in ipairs(column_lines) do
                    -- Try bracketed first, then non-bracketed
                    local name, type_and_rest = col_line.content:match("^%s*(%[.-%])%s+(.+)")
                    local is_bracketed = true
                    
                    if not name then
                      name, type_and_rest = col_line.content:match("^%s*([^%s]+)%s+(.+)")
                      is_bracketed = false
                    end
                    
                    if name and type_and_rest then
                      -- Add brackets to length calculation if not already bracketed
                      if not is_bracketed then
                        name = "[" .. name .. "]"
                      end
                      
                      local type_part = type_and_rest:match("^([^%s]+)")
                      if type_part then
                        max_name_len = math.max(max_name_len, #name)
                        max_type_len = math.max(max_type_len, #type_part)
                      end
                    end
                  end
                  
                  -- Align columns - handle both bracketed and non-bracketed names
                  for _, col_line in ipairs(column_lines) do
                    -- Try bracketed first, then non-bracketed
                    local name, type_and_rest = col_line.content:match("^%s*(%[.-%])%s+(.+)")
                    local is_bracketed = true
                    
                    if not name then
                      name, type_and_rest = col_line.content:match("^%s*([^%s]+)%s+(.+)")
                      is_bracketed = false
                    end
                    
                    if name and type_and_rest then
                      -- Add brackets if not already bracketed
                      if not is_bracketed then
                        name = "[" .. name .. "]"
                      end
                      
                      local type_part, rest = type_and_rest:match("^([^%s]+)%s*(.*)")
                      if type_part then
                        local aligned = string.format("    %-" .. max_name_len .. "s %-" .. max_type_len .. "s %s",
                                                     name, type_part, rest or "")
                        table.insert(aligned_lines, aligned)
                      else
                        table.insert(aligned_lines, col_line.content)
                      end
                    else
                      table.insert(aligned_lines, col_line.content)
                    end
                  end
                end
                
                table.insert(aligned_lines, line)
                in_table = false
                column_lines = {}
              elseif in_table and (line:match("^%s*%[") or line:match("^%s*[%w_]+%s+[%w%(%)]+")) then
                table.insert(column_lines, {content = line, index = i})
              else
                if not in_table then
                  table.insert(aligned_lines, line)
                end
              end
            end
            
            -- Replace buffer content
            vim.api.nvim_buf_set_lines(0, 0, -1, false, aligned_lines)
          end, { desc = "Format and Align SQL", buffer = true })
        end,
      })


      -- DISABLE all auto-formatting for SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        group = vim.api.nvim_create_augroup("SqlNoAutoFormat", { clear = true }),
        callback = function()
          -- Disable LSP formatting
          vim.b.autoformat = false
          
          -- Disable conform auto-formatting
          vim.b.disable_autoformat = true
          
          -- Remove any existing BufWritePre autocmds for this buffer
          vim.api.nvim_clear_autocmds({
            group = "LazyVim",
            buffer = 0,
            event = "BufWritePre",
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
