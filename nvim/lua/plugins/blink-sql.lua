-- Blink.cmp SQL-specific enhancements
-- Add this as a new file or merge with your existing blink.lua

return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    -- Enhanced SQL completion sources
    opts.sources = opts.sources or {}
    opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }

    -- Add SQL-specific completion behavior
    opts.sources.providers = opts.sources.providers or {}

    -- Enhanced LSP provider for SQL
    opts.sources.providers.lsp = vim.tbl_extend("force", opts.sources.providers.lsp or {}, {
      name = "LSP",
      module = "blink.cmp.sources.lsp",
      score_offset = 1000, -- Prioritize LSP completions for SQL
      opts = {
        -- Better SQL keyword completion
        get_trigger_characters = function()
          return { ".", "@", "#", "[", "(", " " } -- SQL-specific triggers
        end,
      },
    })

    -- Better buffer completion for SQL files
    opts.sources.providers.buffer = vim.tbl_extend("force", opts.sources.providers.buffer or {}, {
      opts = {
        -- Include more SQL-like patterns in buffer completion
        get_bufnrs = function()
          -- Include all SQL buffers for better completion context
          local bufs = {}
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype:match("sql") then
              table.insert(bufs, buf)
            end
          end
          return bufs
        end,
      },
    })

    -- SQL-specific completion configuration
    opts.completion = vim.tbl_extend("force", opts.completion or {}, {
      keyword_length = 1, -- Start completion after 1 character for SQL
      trigger_characters = { ".", "@", "#", "[", "(", " " },

      -- Better completion menu for SQL
      menu = vim.tbl_extend("force", opts.completion.menu or {}, {
        max_items = 50, -- Show more items for SQL (many keywords/functions)
        draw = {
          columns = {
            { "kind_icon", "label", gap = 1 },
            { "source_name" },
          },
        },
      }),

      -- Enhanced ghost text for SQL
      ghost_text = vim.tbl_extend("force", opts.completion.ghost_text or {}, {
        enabled = true,
      }),
    })

    -- SQL-specific keymaps within completion menu
    opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
      preset = "super-tab",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-f>"] = { "scroll_documentation_down" },
      ["<C-b>"] = { "scroll_documentation_up" },
    })

    return opts
  end,

  -- SQL-specific autocmds for blink.cmp
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        -- Enable more aggressive completion for SQL files
        vim.opt_local.completeopt = "menu,menuone,noselect,noinsert"

        -- SQL-specific completion settings
        vim.b.blink_cmp_config = {
          sources = {
            default = { "lsp", "buffer", "snippets" }, -- Prioritize LSP for SQL
          },
          completion = {
            keyword_length = 1, -- More aggressive completion for SQL
            trigger_characters = { ".", "@", "#", "[", "(", " ", "'" },
          },
        }
      end,
    })
  end,
}
