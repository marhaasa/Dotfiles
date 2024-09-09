local response_format = "Respond EXACTLY in this format:\n```$ftype\n<your code>\n```"
return {
  "nomnivore/ollama.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  -- All the user commands added by the plugin
  cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

  keys = {
    -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
    {
      "<leader>oo",
      ":<c-u>lua require('ollama').prompt()<cr>",
      desc = "ollama prompt",
      mode = { "n", "v" },
    },

    -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
    {
      "<leader>oG",
      ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
      desc = "ollama Generate Code",
      mode = { "n", "v" },
    },
  },

  ---@type Ollama.Config
  opts = {
    model = "mistral-nemo:latest",
    url = "http://127.0.0.1:11434",
    serve = {
      on_start = false,
      command = "ollama",
      args = { "serve" },
      stop_command = "pkill",
      stop_args = { "-SIGTERM", "ollama" },
    },
    -- View the actual default prompts in ./lua/ollama/prompts.lua
    prompts = {

      Add_Comments = {
        prompt = "Add clear and consise comments to this code to make it both simple to understand and elaborate. Do not edit the actual code and keep all the original code in your answer together with comments."
          .. response_format
          .. "\n\n```$ftype\n$sel```",
        model = "deepseek-coder-v2:latest",
        action = "replace",
      },
      Add_summary = {
        prompt = "Add a summary of this text at the bottom. Keep the original text and make sure the summary is in the same language as the text itself."
          .. response_format
          .. "\n\n```$ftype\n$sel```",
        model = "llama3.1:8b",
        action = "replace",
      },
      Raw = { model = "llama3.1:8b" },
    },
  },
}
