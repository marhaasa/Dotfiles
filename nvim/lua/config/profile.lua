-- Performance profiling and monitoring tools
-- Use these to identify performance bottlenecks

local M = {}

-- Startup time profiler
function M.startup_time()
  vim.cmd("Lazy profile")
end

-- Current session stats
function M.session_stats()
  local stats = {
    loaded_plugins = #vim.tbl_keys(require("lazy").plugins()),
    uptime = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time or vim.fn.reltime())),
    memory_usage = math.floor(vim.fn.system("ps -o rss= -p " .. vim.fn.getpid()) / 1024) .. "MB",
    buffer_count = #vim.api.nvim_list_bufs(),
    window_count = #vim.api.nvim_list_wins(),
  }
  
  print("=== Neovim Session Stats ===")
  print("Uptime: " .. stats.uptime .. "s")
  print("Memory: " .. stats.memory_usage)
  print("Loaded plugins: " .. stats.loaded_plugins)
  print("Buffers: " .. stats.buffer_count)
  print("Windows: " .. stats.window_count)
end

-- Check what's slowing down startup
function M.profile_startup()
  vim.cmd("Lazy profile")
  print("\nTo profile startup time more detailed:")
  print("nvim --startuptime /tmp/startup.log +q && sort -k2 -nr /tmp/startup.log | head -20")
end

-- Performance commands
vim.api.nvim_create_user_command("ProfileStartup", M.startup_time, { desc = "Show plugin startup times" })
vim.api.nvim_create_user_command("SessionStats", M.session_stats, { desc = "Show current session statistics" })
vim.api.nvim_create_user_command("ProfileHelp", M.profile_startup, { desc = "Show profiling help" })

-- Keymaps for quick access
vim.keymap.set("n", "<leader>ps", M.session_stats, { desc = "Performance: Session stats" })
vim.keymap.set("n", "<leader>pp", M.startup_time, { desc = "Performance: Plugin profile" })

return M