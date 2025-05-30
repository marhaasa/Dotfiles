return {
  "tpope/vim-dadbod",
  ft = "sql",
  init = function()
    -- Default database
    vim.g.db = "postgres://airflow:airflow@localhost/airflow?sslmode=disable"
    
    -- Define multiple database connections
    vim.g.dbs = {
      postgres_local = "postgres://airflow:airflow@localhost/airflow?sslmode=disable",
      -- azure_sql = "sqlserver://username:password@server.database.windows.net:1433/database?encrypt=true",
    }
  end,
  keys = {
    {
      "<leader>de",
      function()
        vim.cmd("silent! %DB")
        vim.cmd("redraw!")
      end,
      desc = "Execute entire SQL file",
      ft = "sql",
    },
    {
      "<leader>dv",
      function()
        vim.cmd("silent! '<,'>DB")
        vim.cmd("redraw!")
      end,
      desc = "Execute selected SQL",
      mode = "v",
      ft = "sql",
    },
    {
      "<leader>dl",
      function()
        vim.cmd("silent! .DB")
        vim.cmd("redraw!")
      end,
      desc = "Execute current line",
      ft = "sql",
    },
    {
      "<leader>dae",
      function()
        -- Fabric Data Warehouse execute entire file
        local fabric_server = "ogwupd6kis7url7dk24tmcsesu-3wwj7w55c4kerp2waqlbtjkl44.datawarehouse.fabric.microsoft.com"
        local database = vim.fn.input("Database name (or press Enter for default): ")
        if database == "" then
          database = "master" -- Default database
        end
        
        local temp_file = vim.fn.tempname() .. ".sql"
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        vim.fn.writefile(lines, temp_file)
        
        -- Execute and capture output
        local cmd = string.format("sqlcmd -G -S %s -d %s -i %s", fabric_server, database, temp_file)
        local output = vim.fn.system(cmd)
        vim.fn.delete(temp_file)
        
        -- Display output in a split window like regular dadbod
        vim.cmd('botright split')
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(buf, 'filetype', 'dbout')
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))
        vim.api.nvim_win_set_buf(0, buf)
        vim.cmd('resize 15')
      end,
      desc = "Execute SQL file on Fabric DW (AAD auth)",
      ft = "sql",
    },
    {
      "<leader>dal",
      function()
        -- Fabric Data Warehouse execute current line
        local fabric_server = "ogwupd6kis7url7dk24tmcsesu-3wwj7w55c4kerp2waqlbtjkl44.datawarehouse.fabric.microsoft.com"
        local database = vim.fn.input("Database name (or press Enter for default): ")
        if database == "" then
          database = "master" -- Default database
        end
        
        local line = vim.api.nvim_get_current_line()
        local temp_file = vim.fn.tempname() .. ".sql"
        vim.fn.writefile({line}, temp_file)
        
        -- Execute and capture output
        local cmd = string.format("sqlcmd -G -S %s -d %s -i %s", fabric_server, database, temp_file)
        local output = vim.fn.system(cmd)
        vim.fn.delete(temp_file)
        
        -- Display output in a split window like regular dadbod
        vim.cmd('botright split')
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(buf, 'filetype', 'dbout')
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))
        vim.api.nvim_win_set_buf(0, buf)
        vim.cmd('resize 15')
      end,
      desc = "Execute current line on Fabric DW (AAD auth)",
      ft = "sql",
    },
  },
}