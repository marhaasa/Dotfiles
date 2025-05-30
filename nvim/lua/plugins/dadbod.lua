return {
  "tpope/vim-dadbod",
  ft = "sql",
  init = function()
    vim.g.db = "postgres://airflow:airflow@localhost/airflow?sslmode=disable"
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
  },
}