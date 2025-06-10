return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = "rafamadriz/friendly-snippets",

  -- use a release tag to download pre-built binaries
  version = "*",
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = function(_, opts)
    opts = opts or {}
    
    -- Base configuration
    opts.keymap = { preset = "super-tab" }
    
    opts.appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",
    }

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    opts.sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        markdown = {
          name = "RenderMarkdown",
          module = "render-markdown.integ.blink",
          fallbacks = { "lsp" },
        },
        -- Better buffer completion for SQL files
        buffer = {
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
        },
      },
    }

    -- SQL-specific completion configuration
    opts.completion = {
      list = {
        max_items = 50, -- Show more items for SQL (many keywords/functions)
      },
      menu = {
        draw = {
          columns = {
            { "kind_icon", "label", gap = 1 },
            { "source_name" },
          },
        },
      },
      ghost_text = {
        enabled = true,
      },
    }

    -- Enhanced keymaps
    opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
      preset = "super-tab",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-f>"] = { "scroll_documentation_down" },
      ["<C-b>"] = { "scroll_documentation_up" },
    })

    return opts
  end,

  -- SQL-specific autocmds
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        -- Enable more aggressive completion for SQL files
        vim.opt_local.completeopt = "menu,menuone,noselect,noinsert"

        -- SQL-specific completion settings
        vim.b.blink_cmp_config = {
          sources = {
            default = { "buffer", "snippets", "path" }, -- Use buffer/snippets since sqls LSP may be disabled
          },
        }
      end,
    })
  end,
  
  opts_extend = { "sources.default" },
}
