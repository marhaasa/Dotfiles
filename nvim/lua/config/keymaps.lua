-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- See KEYMAPS.md for a comprehensive reference of all keymaps

-- ============================================================================
-- 🤖 COMPLETION CONTROLS
-- ============================================================================
vim.keymap.set("n", "<leader>p", '<cmd>lua require("cmp").setup { enabled = true }<cr>', { desc = "Enable completion" })
vim.keymap.set("n", "<leader>P", '<cmd>lua require("cmp").setup { enabled = false }<cr>', { desc = "Disable completion" })

-- ============================================================================
-- 🔍 SEARCH & NAVIGATION ENHANCEMENTS
-- ============================================================================

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Keep cursor centered when searching
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Telescope keymaps (override LazyVim defaults)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files (Custom)" })
vim.keymap.set("n", "<leader>ft", "<cmd>Telescope live_grep<cr>", { desc = "Find Text (Custom)" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope symbols<cr>", { desc = "Find Symbols (Custom)" })

-- ============================================================================
-- 📝 TEXT EDITING & FORMATTING
-- ============================================================================

-- Word operations
vim.keymap.set("n", "<leader>wsq", 'ciw""<Esc>P', { desc = "Surround word with quotes" })

-- Text replacement
vim.keymap.set("n", "<leader>rbs", "<cmd>%s/\\//g<CR>", { desc = "Replace backward slashes" })
vim.keymap.set("n", "<leader>rlt", "<cmd>lua require('textcase').current_word('to_title_case')<CR>", { desc = "Convert word to title case" })

-- ============================================================================
-- 📅 DATE & TIME INSERTION
-- ============================================================================
vim.keymap.set("n", "<leader>d", "<cmd>r!gendate<cr>", { desc = "Insert current date" })
vim.keymap.set("n", "<leader>h1", "<cmd>r!gendate h 1<cr>", { desc = "Insert date as H1 header" })
vim.keymap.set("n", "<leader>h2", "<cmd>r!gendate h 2<cr>", { desc = "Insert date as H2 header" })

-- ============================================================================
-- 🛠️ DEVELOPMENT TOOLS
-- ============================================================================

-- LSP controls
vim.keymap.set("n", "<leader>S", "<cmd>LspStop<CR>", { desc = "Stop LSP server" })

-- Go development
vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { desc = "Run Go tests" })

-- Note: LazyGit keymap (<leader>lg) defined in lazygit.lua for lazy loading
-- Note: No Neck Pain keymap (<leader>nn) defined in no-neckpain.lua for lazy loading

-- ============================================================================
-- 🎬 CONTENT CREATION
-- ============================================================================
vim.keymap.set("n", "<leader>hy", "i{{< youtube id >}}<Esc>", { desc = "Insert Hugo YouTube shortcode" })

-- ============================================================================
-- 📝 NOTE TAKING (ZETTELKASTEN)
-- ============================================================================

-- Note creation and navigation functions
local function create_and_open_new_note()
  local line = vim.api.nvim_get_current_line()
  local title = line:match("%[%[(.-)%]%]")

  if title then
    local cmd = string.format('scribe new --vim "%s"', title)
    local output = vim.fn.system(cmd)
    local file_path = output:match("New note created: (.+)")
    
    if file_path then
      file_path = file_path:gsub("%z", ""):gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1")
      vim.cmd("badd " .. vim.fn.fnameescape(file_path))
      local bufnr = vim.fn.bufnr(file_path)
      vim.api.nvim_set_current_buf(bufnr)
      print("Created and opened new note: " .. title)
    else
      print("Failed to create note: " .. title)
    end
  else
    print("No title found between double square brackets")
  end
end

local function yank_and_open_markdown_link()
  vim.cmd("normal! yi]")
  local yanked_text = vim.fn.getreg('"')
  yanked_text = yanked_text:gsub("%[%[(.-)%]%]", "%1")

  if yanked_text == "" then
    print("No text found inside brackets")
    return
  end

  local scan = require("plenary.scandir")
  
  -- Search in notes directory first, fall back to current directory
  local notes_dir = vim.fn.expand("~/notes")
  local search_dir = vim.fn.isdirectory(notes_dir) == 1 and notes_dir or vim.loop.cwd()
  
  -- Properly escape all special characters for Lua patterns
  local function escape_pattern(text)
    -- Escape all Lua pattern special characters
    return text:gsub("([%.%^%$%(%)%[%]%*%+%-%?])", "%%%1")
  end
  
  local escaped_text = escape_pattern(yanked_text)
  
  local files = scan.scan_dir(search_dir, {
    depth = 5,
    hidden = true,
    add_dirs = false,
    search_pattern = ".*" .. escaped_text .. ".*%.md$",
  })

  if #files > 0 then
    vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
  else
    print("No file found matching: " .. yanked_text)
  end
end

-- Note-taking keymaps
vim.keymap.set("n", "<leader>zn", create_and_open_new_note, { desc = "Create and open new note" })
vim.keymap.set("n", "<leader>zo", yank_and_open_markdown_link, { desc = "Open note from link" })

-- ============================================================================
-- 🗃️ DATABASE OPERATIONS
-- ============================================================================

-- Database connection helpers
local function execute_sql_with_dadbod(range)
  local cmd = range == "file" and "silent! %DB" or 
             range == "visual" and "silent! '<,'>DB" or 
             range == "line" and "silent! .DB" or ""
  if cmd ~= "" then
    vim.cmd(cmd)
    vim.cmd("redraw!")
  end
end

local function execute_fabric_sql(range)
  local fabric_server = os.getenv("FABRIC_SERVER") or "your-fabric-server.datawarehouse.fabric.microsoft.com"
  local database = vim.fn.input("Database name (or press Enter for default): ")
  if database == "" then
    database = "master"
  end
  
  local content, temp_file
  if range == "file" then
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    temp_file = vim.fn.tempname() .. ".sql"
    vim.fn.writefile(lines, temp_file)
  elseif range == "line" then
    local line = vim.api.nvim_get_current_line()
    temp_file = vim.fn.tempname() .. ".sql"
    vim.fn.writefile({line}, temp_file)
  end
  
  if temp_file then
    local cmd = string.format("sqlcmd -G -S %s -d %s -i %s", fabric_server, database, temp_file)
    local output = vim.fn.system(cmd)
    vim.fn.delete(temp_file)
    
    -- Display output in split window
    vim.cmd('botright split')
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'dbout')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))
    vim.api.nvim_win_set_buf(0, buf)
    vim.cmd('resize 15')
  end
end

-- SQL Database keymaps (SQL files only)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    local opts = { buffer = true }
    
    -- Note: Basic vim-dadbod operations (<leader>de, <leader>dv, <leader>dl) are defined in dadbod.lua
    
    -- Fabric Data Warehouse operations (custom Azure integration)
    vim.keymap.set("n", "<leader>dae", function() execute_fabric_sql("file") end, 
      vim.tbl_extend("force", opts, { desc = "Execute SQL file on Fabric DW" }))
    vim.keymap.set("n", "<leader>dal", function() execute_fabric_sql("line") end, 
      vim.tbl_extend("force", opts, { desc = "Execute current line on Fabric DW" }))
    
    -- Note: SQL formatting keymaps (<leader>fmt, <leader>fma) are defined in sql-formatter.lua
  end,
})

-- ============================================================================
-- 🤖 AI INTEGRATION (GP.NVIM)
-- ============================================================================

-- GP.nvim keymaps are defined in gp.lua plugin file due to their complexity
-- and tight integration with the plugin configuration. They use <C-g> prefix.
-- See KEYMAPS.md for full reference of all GP.nvim keymaps.

-- ============================================================================
-- 📝 COMMANDS
-- ============================================================================

-- Create user commands for note-taking functions
vim.api.nvim_create_user_command("CreateAndOpenNewNote", create_and_open_new_note, {})
vim.api.nvim_create_user_command("YankAndSearchMarkdownLink", yank_and_open_markdown_link, {})