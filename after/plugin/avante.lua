print("Setting up avante")
require("avante").setup({
  -- Input UI (fine as-is)
  input = {
    provider = "snacks",
    provider_opts = {
      title = "Avante Input",
      icon = " ",
      placeholder = "Enter your API key...",
    },
  },

  -- ✅ Explicit default provider
  provider = "openai",

  -- ✅ Explicit provider table
  providers = {
    -- 🚫 Disable Claude entirely
    claude = {
      enabled = false,
    },

    -- ✅ Enable OpenAI explicitly
    openai = {
      enabled = true,
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4o",
      timeout = 30000,
      extra_request_body = {
        temperature = 0,
        max_tokens = 4096,
      },
    },
  },
})

vim.api.nvim_create_user_command("Avgpt", function()
	require("avante.api").switch_provider("openai")
end,
{}
)
