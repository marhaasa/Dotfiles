return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      sqls = {
        settings = {
          sqls = {
            connections = {
              {
                driver = "postgresql",
                dataSourceName = "postgres://airflow:airflow@localhost/airflow?sslmode=disable",
              },
            },
          },
        },
      },
    },
  },
}