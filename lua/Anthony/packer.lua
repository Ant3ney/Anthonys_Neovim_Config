-- packer.lua — UE-first with Unreal.nvim, single clangd, + Harpoon

-- Bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "--depth", "1",
    "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd("packadd packer.nvim")
end

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

-- init.lua (or lua/plugins.lua)
  use 'neovim/nvim-lspconfig'     -- LSP client configs
  use 'hrsh7th/nvim-cmp'          -- completion UI
  use 'hrsh7th/cmp-nvim-lsp'      -- LSP source for nvim-cmp
  use 'L3MON4D3/LuaSnip'          -- snippet engine (tiny, no config needed)
  use 'saadparwaiz1/cmp_luasnip'  -- bridge: cmp -> luasnip
  ---------------------------------------------------------------------------
  -- Unreal Engine (primary)
  ---------------------------------------------------------------------------
  use {'zadirion/Unreal.nvim',
    requires =
    {
        {"tpope/vim-dispatch"}
    }
  }

  ---------------------------------------------------------------------------
  -- LSP: mason + lspconfig (single clangd, Windows/MSVC friendly)
  ---------------------------------------------------------------------------
--  use {
--    "neovim/nvim-lspconfig",
--    requires = {
--      "williamboman/mason.nvim",
--      "williamboman/mason-lspconfig.nvim",
--    },
--    config = function()
--      --require("mason").setup({})
--      --require("mason-lspconfig").setup({
--        --ensure_installed = { "clangd" },
--        --automatic_installation = true,
--      --})
--
--      local lspconfig = require("lspconfig")
--      local util      = require("lspconfig.util")
--
--      local is_win    = vim.loop.os_uname().version:match("Windows")
--      local clangd_exe= vim.fn.stdpath("data") .. "/mason/bin/clangd" .. (is_win and ".cmd" or "")
--
--      local rooter = util.root_pattern("*.uproject", "compile_commands.json", ".git")
--
--      local caps = vim.lsp.protocol.make_client_capabilities()
--      caps.offsetEncoding = { "utf-8", "utf-16" }
--      caps.textDocument = caps.textDocument or {}
--      caps.textDocument.completion = { editsNearCursor = true }
--
--      lspconfig.clangd.setup({
--        cmd = { "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\Llvm\\x64\\bin\\clangd.exe" },
--        root_dir = function(fname) return rooter(fname) or util.path.dirname(fname) end,
--        args = {
--          "--background-index",
--          "--clang-tidy",
--          "--header-insertion=never",
--          [[--query-driver=C:/Program Files/Microsoft Visual Studio/*/VC/Tools/MSVC/*/bin/**/cl.exe]],
--        },
--        capabilities = caps,
--      })
--
--      -- Optional: Lua LSP for editing config
--      lspconfig.lua_ls.setup({
--        root_dir = util.root_pattern(".git", ".luarc.json", ".luacheckrc"),
--        settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } },
--      })
--    end,
--  }


  ---------------------------------------------------------------------------
  -- Treesitter / Telescope / Colors
  ---------------------------------------------------------------------------
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
        highlight = { enable = true },
      })
    end,
  }

  use { "nvim-telescope/telescope.nvim", tag = "0.1.8", requires = { "nvim-lua/plenary.nvim" } }

  use { "folke/tokyonight.nvim", config = function() vim.cmd("colorscheme tokyonight") end }

  ---------------------------------------------------------------------------
  -- Harpoon (restored)
  ---------------------------------------------------------------------------
  use {
    "theprimeagen/harpoon",
    config = function()
      -- mini-defaults; tweak as you like
      local mark = require("harpoon.mark")
      local ui   = require("harpoon.ui")
    end,
  }
end)


