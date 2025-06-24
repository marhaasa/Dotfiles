# Neovim Keymap Reference

This file documents all custom keymaps in this Neovim configuration. All keymaps are centralized in `lua/config/keymaps.lua`.

## Leader Key
The leader key is `<Space>` (set by LazyVim default).

## Keymap Organization

**Centralized Location**: Most keymaps are in `lua/config/keymaps.lua`

**Plugin-Specific**: Some keymaps remain in plugin files for lazy-loading:
- Telescope keymaps: `lua/plugins/telescope.lua`
- LazyGit keymaps: `lua/plugins/lazygit.lua` 
- No Neck Pain keymaps: `lua/plugins/no-neckpain.lua`
- Basic SQL keymaps: `lua/plugins/dadbod.lua`
- GP.nvim (AI) keymaps: `lua/plugins/gp.lua`

## Keymap Categories

### 🔍 **Search & Navigation**
| Key | Mode | Description | Location |
|-----|------|-------------|----------|
| `<leader>ff` | n | Find Files | telescope.lua |
| `<leader>ft` | n | Find text in files | telescope.lua |
| `<leader>fs` | n | Find Symbols | telescope.lua |
| `<C-d>` | n | Scroll down + center cursor | keymaps.lua |
| `<C-u>` | n | Scroll up + center cursor | keymaps.lua |
| `n` | n | Next search + center cursor | keymaps.lua |
| `N` | n | Previous search + center cursor | keymaps.lua |

### 📝 **Text Editing & Formatting**
| Key | Mode | Description | Plugin/Function |
|-----|------|-------------|-----------------|
| `<leader>wsq` | n | Surround word with quotes | Custom function |
| `<leader>rbs` | n | Replace backward slashes | Custom function |
| `<leader>rlt` | n | Convert line to title case | textcase.nvim |
| `<leader>f` | n | Format SQL (SQL files only) | conform.nvim |
| `<leader>fa` | n | Format and align SQL (SQL files only) | conform.nvim |


### 📝 **Note Taking (Zettelkasten)**
| Key | Mode | Description | Plugin/Function |
|-----|------|-------------|-----------------|
| `<leader>zn` | n | Create and open new note | scribe CLI |
| `<leader>zo` | n | Open existing note from link | Custom function |

### 🗃️ **Database Operations**

#### **Query Execution**
| Key | Mode | Description | Location |
|-----|------|-------------|----------|
| `<leader>de` | n | Execute entire SQL file | dadbod.lua |
| `<leader>dv` | v | Execute selected SQL | dadbod.lua |
| `<leader>dl` | n | Execute current SQL line | dadbod.lua |
| `<leader>dae` | n | Execute SQL file on Fabric DW | keymaps.lua |
| `<leader>dal` | n | Execute current line on Fabric DW | keymaps.lua |

#### **Database Introspection**
| Key | Mode | Description | Location |
|-----|------|-------------|----------|
| `<leader>dt` | n | Show all tables (all schemas) | dadbod.lua |
| `<leader>di` | n | Show all tables (all schemas) | dadbod.lua |
| `<leader>dc` | n | Describe table columns (supports schema.table) | dadbod.lua |
| `<leader>dp` | n | Show public schema tables only | dadbod.lua |
| `<leader>ds` | n | Show all schemas | dadbod.lua |
| `<leader>dS` | n | Show tables for specific schema (prompt) | dadbod.lua |

#### **SQL Formatting**
| Key | Mode | Description | Location |
|-----|------|-------------|----------|
| `<leader>fmt` | n | Format SQL (SQL files only) | sql-formatter.lua |
| `<leader>fma` | n | Format and align SQL (SQL files only) | sql-formatter.lua |

### 🛠️ **Development Tools**
| Key | Mode | Description | Location |
|-----|------|-------------|----------|
| `<leader>lg` | n | Open LazyGit | lazygit.lua |
| `<leader>gt` | n | Run Go tests | keymaps.lua |
| `<leader>S` | n | Stop LSP server | keymaps.lua |
| `<leader>nn` | n | Toggle No Neck Pain | no-neckpain.lua |

### 🤖 **AI & Completion**
| Key | Mode | Description | Plugin/Function |
|-----|------|-------------|-----------------|
| `<leader>ce` | n | Enable blink completion | blink.cmp |
| `<leader>cd` | n | Disable blink completion | blink.cmp |

#### **GP.nvim (AI Chat) - `<C-g>` prefix**
| Key | Mode | Description |
|-----|------|-------------|
| `<C-g>c` | n,i | New Chat |
| `<C-g>t` | n,i | Toggle Chat |
| `<C-g>f` | n,i | Chat Finder |
| `<C-g>p` | v | Visual Chat Paste |
| `<C-g><C-x>` | n,i | New Chat split |
| `<C-g><C-v>` | n,i | New Chat vsplit |
| `<C-g><C-t>` | n,i | New Chat tabnew |
| `<C-g>r` | n,i,v | Rewrite text |
| `<C-g>a` | n,i,v | Append text |
| `<C-g>b` | n,i,v | Prepend text |
| `<C-g>i` | v | Implement selection |
| `<C-g>gp` | n,i,v | Popup |
| `<C-g>ge` | n,i,v | New buffer |
| `<C-g>gn` | n,i,v | New |
| `<C-g>gv` | n,i,v | Vertical new |
| `<C-g>gt` | n,i,v | Tab new |
| `<C-g>x` | n,i,v | Toggle Context |
| `<C-g>s` | n,i,v,x | Stop |
| `<C-g>n` | n,i,v,x | Next Agent |

#### **Whisper (Speech-to-text) - `<C-g>w` prefix**
| Key | Mode | Description |
|-----|------|-------------|
| `<C-g>ww` | n,i,v | Whisper transcribe |
| `<C-g>wr` | n,i,v | Whisper rewrite |
| `<C-g>wa` | n,i,v | Whisper append |
| `<C-g>wb` | n,i,v | Whisper prepend |
| `<C-g>wp` | n,i,v | Whisper popup |
| `<C-g>we` | n,i,v | Whisper new buffer |
| `<C-g>wn` | n,i,v | Whisper new |
| `<C-g>wv` | n,i,v | Whisper vertical |
| `<C-g>wt` | n,i,v | Whisper tab new |

### 🎬 **Content Creation**
| Key | Mode | Description | Plugin/Function |
|-----|------|-------------|-----------------|
| `<leader>hy` | n | Insert Hugo YouTube shortcode | Custom snippet |

## Environment Variables Required

For database operations to work properly, set these environment variables:
- `DB_URL` - Default database connection string
- `DB_POSTGRES_LOCAL` - Local PostgreSQL connection
- `FABRIC_SERVER` - Microsoft Fabric server URL

## Notes

- All SQL-related keymaps are only active in SQL file types
- GP.nvim keymaps are available globally for quick AI access
- Date insertion uses the `gendate` command (must be in PATH)
- Note-taking functions require `scribe` CLI tool
- Some keymaps may conflict with LazyVim defaults - check `:map` for conflicts