return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure sqls is completely disabled
      opts.servers = opts.servers or {}
      opts.servers.sqls = false
      opts.servers.sqlls = {}

      -- Also try to disable via setup
      opts.setup = opts.setup or {}
      opts.setup.sqls = function()
        return true -- returning true prevents setup
      end

      return opts
    end,
  },
}
