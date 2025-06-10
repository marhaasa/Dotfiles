return {
  "tpope/vim-dadbod",
  ft = "sql",
  init = function()
    -- Default database from environment variable
    vim.g.db = os.getenv("DB_URL") or "postgres://airflow:airflow@localhost/airflow?sslmode=disable"
    
    -- Define multiple database connections
    vim.g.dbs = {
      postgres_local = os.getenv("DB_POSTGRES_LOCAL") or "postgres://airflow:airflow@localhost/airflow?sslmode=disable",
      -- azure_sql = os.getenv("DB_AZURE_SQL") or "sqlserver://username:password@server.database.windows.net:1433/database?encrypt=true",
    }
  end,
  keys = {
    { "<leader>de", "<cmd>%DB<cr>", desc = "Execute entire SQL file", ft = "sql" },
    { "<leader>dv", ":'<,'>DB<cr>", desc = "Execute selected SQL", mode = "v", ft = "sql" },
    { "<leader>dl", "<cmd>.DB<cr>", desc = "Execute current line", ft = "sql" },
    { "<leader>dt", "<cmd>DB SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema NOT IN ('information_schema', 'pg_catalog', 'pg_toast') AND table_type = 'BASE TABLE' ORDER BY table_schema, table_name;<cr>", desc = "Show all tables (all schemas)", ft = "sql" },
  },
  config = function()
    -- Configure vim-dadbod settings
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_force_echo_messages = 1
    
    -- Create useful SQL snippets/shortcuts
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        local opts = { buffer = true, silent = true }
        
        -- Database introspection commands (PostgreSQL-focused)
        vim.keymap.set("n", "<leader>di", function()
          -- Show all tables from all non-system schemas (PostgreSQL)
          vim.cmd("DB SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema NOT IN ('information_schema', 'pg_catalog', 'pg_toast') AND table_type = 'BASE TABLE' ORDER BY table_schema, table_name;")
        end, vim.tbl_extend("force", opts, { desc = "Show all tables (all schemas)" }))
        
        vim.keymap.set("n", "<leader>dc", function()
          local table_input = vim.fn.input("Describe table (schema.table or just table): ")
          if table_input ~= "" then
            local schema, table_name
            -- Check if input contains schema.table format
            if string.match(table_input, "%.") then
              schema, table_name = string.match(table_input, "^(.+)%.(.+)$")
            else
              -- Default to public schema if no schema specified
              schema = "public"
              table_name = table_input
            end
            
            if schema and table_name then
              -- PostgreSQL syntax for describing table structure with schema
              vim.cmd("DB SELECT column_name, data_type, is_nullable, column_default, character_maximum_length FROM information_schema.columns WHERE table_name = '" .. table_name .. "' AND table_schema = '" .. schema .. "' ORDER BY ordinal_position;")
            end
          end
        end, vim.tbl_extend("force", opts, { desc = "Describe table columns (supports schema.table)" }))
        
        vim.keymap.set("n", "<leader>dp", function()
          -- Show only public schema tables
          vim.cmd("DB SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY table_name;")
        end, vim.tbl_extend("force", opts, { desc = "Show public schema tables only" }))
        
        vim.keymap.set("n", "<leader>ds", function()
          -- Show all schemas
          vim.cmd("DB SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast') ORDER BY schema_name;")
        end, vim.tbl_extend("force", opts, { desc = "Show all schemas" }))
        
        vim.keymap.set("n", "<leader>dS", function()
          -- Show schema-specific tables
          local schema = vim.fn.input("Show tables for schema (default: public): ")
          if schema == "" then
            schema = "public"
          end
          vim.cmd("DB SELECT table_name FROM information_schema.tables WHERE table_schema = '" .. schema .. "' AND table_type = 'BASE TABLE' ORDER BY table_name;")
        end, vim.tbl_extend("force", opts, { desc = "Show tables for specific schema" }))
        
        -- Enhance buffer completion for SQL files
        vim.b.blink_cmp_config = {
          sources = {
            default = { "buffer", "snippets", "path" },
          },
          completion = {
            list = {
              max_items = 50, -- Show more SQL-related completions
            },
          },
        }
      end,
    })
  end,
}