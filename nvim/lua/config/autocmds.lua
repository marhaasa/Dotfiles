-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
-- disable completion on markdown files by default
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    require("cmp").setup({ enabled = false })
  end,
})

-- attemting to disable terraform ls on fixture file
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*fixture*",
--   callback = function()
--     vim.diagnostic.disable(0)
--
--     this one also didnt work:     vim.lsp.stop_client(vim.lsp.get_active_clients())
--   end,
-- })

-- wrap and check for spell in text filetypes
-- added to disable spelling
vim.api.nvim_create_autocmd("FileType", {
  -- group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown", "pandoc" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("filetype", {
  -- group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown", "pandoc" },
  command = "set nospell",
})

-- vim.api.nvim_create_autocmd("filetype", {
--   -- group = augroup("wrap_spell"),
--   pattern = { "pandoc" },
--   command = "PandocFolding none",
-- })

-- Go related

-- Run gofmt + goimport on save

local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
  group = format_sync_grp,
})

vim.api.nvim_create_autocmd("filetype", {
  -- group = augroup("wrap_spell"),
  pattern = { "go" },
  command = 'lua require("cmp").setup { enabled = true }',
})

--vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
--local cmp = require("cmp")
--local cmp_action = require("lsp-zero").cmp_action()
-- configure manual  autocompletion
--cmp.setup({
--  mapping = cmp.mapping.preset.insert({
--    -- tab completion
--    ["<Tab>"] = cmp_action.tab_complete(),
--    ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
--  }),
--})

-- autocmd for .sql files to use poor mans T-SQL formatter on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.sql",
  command = ":%!sqlformat",
})

function _G.extract_tasks_and_remind()
  -- Redirect the output of the :g command to a variable
  vim.cmd("silent! redir => tasks")
  vim.cmd("silent! g/TODO:/p")
  vim.cmd("silent! redir END")

  -- Get the tasks
  local tasks = vim.api.nvim_get_var("tasks")

  -- Print the tasks
  print("Sending the following tasks to reminders CLI:\n" .. tasks)

  -- Pass the tasks to the reminders CLI
  for task in tasks:gmatch("[^\r\n]+") do
    -- Remove the "TODO:" prefix from the task
    local task_without_prefix = task:match("^TODO:%s*(.*)")
    -- Set the category to "Jobb"
    local category = "Jobb"
    -- Check if a due date is provided
    if task_without_prefix:find("tid:") then
      -- Extract the description and due date from the task
      local description, due_date = task_without_prefix:match("(.-)%s*tid:%s*(.*)")
      -- Pass the category, description, and due date to the reminders CLI
      os.execute(string.format("reminders add '%s' '%s' --due-date '%s'", category, description, due_date))
    else
      -- Pass the category and description to the reminders CLI
      os.execute(string.format("reminders add '%s' '%s'", category, task_without_prefix))
    end
  end
end
