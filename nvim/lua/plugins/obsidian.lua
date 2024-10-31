return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "/Users/mariushogliaasarod/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes",
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    disable_frontmatter = false,

    note_frontmatter_func = function(note)
      if note.title then
        note:add_alias(note.title)
      end

      note.metadata = note.metadata or {}

      local current_time_utc = os.date("!%Y-%m-%dT%H:%M:%SZ")

      local function get_file_last_modified_time(filepath)
        local stat = vim.loop.fs_stat(filepath)
        return stat and os.date("!%Y-%m-%dT%H:%M:%SZ", stat.mtime.sec) or current_time_utc
      end

      local function convert_to_local_time(utc_time)
        local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)Z"
        local year, month, day, hour, min, sec = utc_time:match(pattern)
        local time_table = {
          year = year,
          month = month,
          day = day,
          hour = hour,
          min = min,
          sec = sec,
          isdst = false,
        }
        local utc_timestamp = os.time(time_table)
        local local_timestamp = utc_timestamp + os.difftime(os.time(), os.time(os.date("!*t")))
        return os.date("%Y-%m-%dT%H:%M:%S", local_timestamp)
      end

      if not note.metadata.date_created then
        local filepath = tostring(note.path)
        note.metadata.date_created = convert_to_local_time(get_file_last_modified_time(filepath))
      end

      note.metadata.date_edited = convert_to_local_time(current_time_utc)

      local out = {
        id = note.id,
        aliases = note.aliases,
        tags = note.tags,
        date_created = note.metadata.date_created,
        date_edited = note.metadata.date_edited,
      }

      if not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,
  },
  ui = {
    enable = true,
    update_debounce = 200,
    max_file_length = 5000,
    checkboxes = {
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
      [">"] = { char = "", hl_group = "ObsidianRightArrow" },
      ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      ["!"] = { char = "", hl_group = "ObsidianImportant" },
    },
    bullets = { char = "•", hl_group = "ObsidianBullet" },
    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    reference_text = { hl_group = "ObsidianRefText" },
    highlight_text = { hl_group = "ObsidianHighlightText" },
    tags = { hl_group = "ObsidianTag" },
    block_ids = { hl_group = "ObsidianBlockID" },
    hl_groups = {
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#008000" }, -- White text on green background
      ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
      ObsidianTilde = { bold = true, fg = "#ff5370" },
      ObsidianImportant = { bold = true, fg = "#d73128" },
      ObsidianBullet = { bold = true, fg = "#89ddff" },
      ObsidianRefText = { underline = true, fg = "#c792ea" },
      ObsidianExtLinkIcon = { fg = "#c792ea" },
      ObsidianTag = { italic = true, fg = "#89ddff" },
      ObsidianBlockID = { italic = true, fg = "#89ddff" },
      ObsidianHighlightText = { bg = "#75662e" },
    },
  },
}
