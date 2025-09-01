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
	-- Tell packer to update and configure itself
	use "wbthomason/packer.nvim"

	use 'hrsh7th/nvim-cmp'          -- completion UI
	use 'hrsh7th/cmp-nvim-lsp'      -- LSP source for nvim-cmp
	use 'L3MON4D3/LuaSnip'          -- snippet engine (tiny, no config needed)
	use 'saadparwaiz1/cmp_luasnip'  -- bridge: cmp -> luasnip

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
	-- Harpoon
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
