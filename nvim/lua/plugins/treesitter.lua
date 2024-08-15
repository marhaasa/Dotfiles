return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "lua",
        "python",
        "javascript",
        "typescript",
        "bash",
        "vimdoc",
        "html",
        "json",
        "query",
        "regex",
        "vim",
        "yaml",
        "go",
        "bicep",
        "terraform",
        "sql",
      },
      highlight = {
        enable = true,
        disable = function(lang)
          local buf_name = vim.fn.expand("%")
          if lang == "terraform" and string.find(buf_name, "fixture") then
            return true
          end
        end,
      },
    })
  end,
}
