-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.ignorecase = true
opt.spell = false
opt.foldmethod = "manual"
opt.foldenable = false

opt.termguicolors = true
-- scrolling
opt.number = true
opt.relativenumber = false
opt.scrolloff = 8
opt.linebreak = true

-- Remove command line and other UI elements
opt.cmdheight = 0
opt.fillchars = { eob = " " }
opt.showtabline = 0
opt.laststatus = 0
opt.ruler = false
opt.showcmd = false
opt.cursorline = false
opt.cursorcolumn = false

-- These functions along with the underlying [scribe CLI](https://github.com/marhaasa/scribe) is heavily borrowed from mischavandenburg
-- This requires scribe to be accessible locally
local function create_and_open_new_note()
  -- Get the current line
  local line = vim.api.nvim_get_current_line()

  -- Extract the title from between double square brackets
  local title = line:match("%[%[(.-)%]%]")

  if title then
    -- Construct and execute the zk command
    local cmd = string.format('scribe new --vim "%s"', title)
    local output = vim.fn.system(cmd)

    -- Extract the file path from the output and clean it
    local file_path = output:match("New note created: (.+)")
    if file_path then
      -- Remove null bytes, newlines, and trim whitespace
      file_path = file_path:gsub("%z", ""):gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1")

      -- Open the file in a new buffer without changing the current window layout
      vim.cmd("badd " .. vim.fn.fnameescape(file_path))
      local bufnr = vim.fn.bufnr(file_path)

      -- Switch to the new buffer in the current window
      vim.api.nvim_set_current_buf(bufnr)

      print("Created and opened new note: " .. title)
      print("File path: " .. file_path) -- Debug print
    else
      print("Failed to create note: " .. title)
      print("Command output: " .. output)
    end
  else
    print("No title found between double square brackets")
  end
end

-- Create a Vim command to call this function
vim.api.nvim_create_user_command("CreateAndOpenNewNote", create_and_open_new_note, {})

-- Optional: Add a key mapping
vim.keymap.set("n", "<leader>zn", ":CreateAndOpenNewNote<CR>", { desc = "Create and open notat" })

local function yank_and_open_markdown_link()
  vim.cmd("normal! yi]")
  local yanked_text = vim.fn.getreg('"')
  yanked_text = yanked_text:gsub("%[%[(.-)%]%]", "%1")

  if yanked_text == "" then
    print("No text found inside brackets")
    return
  end

  -- Escape special characters in the file name
  local escaped = vim.fn.escape(yanked_text, "\\.^$*+?[]")

  -- Use plenary to scan for matching files
  local scan = require("plenary.scandir")
  local files = scan.scan_dir(vim.loop.cwd(), {
    depth = 5,
    hidden = true,
    add_dirs = false,
    search_pattern = escaped .. ".*%.md$",
  })

  if #files > 0 then
    vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
  else
    print("No file found matching: " .. yanked_text)
  end
end

vim.api.nvim_create_user_command("YankAndSearchMarkdownLink", yank_and_open_markdown_link, {})

vim.keymap.set(
  "n",
  "<leader>zo",
  ":YankAndSearchMarkdownLink<CR>",
  { desc = "Zet Open - Yank and search markdown link" }
)
