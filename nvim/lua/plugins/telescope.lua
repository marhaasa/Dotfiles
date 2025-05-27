return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {"nvim-lua/plenary.nvim"}
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files Telescope" },
      { "<leader>ft", "<cmd>Telescope live_grep<cr>", desc = "Find text in files" }
    },
    
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--glob", "!**/.git/*", "-L" },
        },
      },
    },
  },
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  {
    "nvim-telescope/telescope-symbols.nvim",
  },

  -- Custom ripgrep configuration:

  -- I want to search in hidden/dot files.
  -- "--hidden"
  --
  -- I don't want to search in the `.git` directory.
  -- "--glob")
  -- "!**/.git/*")
  --
  --  I want to follow symbolic links
  -- "-L"
  --
}
