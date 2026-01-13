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
      model = "gpt-5.2",
      timeout = 30000,
    },
    behaviour = {
	    use_cwd_as_project_root = true,
    },

  },
})

vim.g.root_spec = { "cwd" } 

vim.api.nvim_create_user_command("Avgpt", function()
	require("avante.api").switch_provider("openai")
end,
{}
)
