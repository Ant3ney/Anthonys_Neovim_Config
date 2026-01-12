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

	---------------------------------------------------------------------------
	-- Avante
	---------------------------------------------------------------------------
	-- Required plugins
	use 'nvim-lua/plenary.nvim'
	use 'MunifTanjim/nui.nvim'
	use 'MeanderingProgrammer/render-markdown.nvim'

	-- Optional dependencies
	use 'hrsh7th/nvim-cmp'
	use 'nvim-tree/nvim-web-devicons' -- or use 'echasnovski/mini.icons'
	use 'HakonHarnes/img-clip.nvim'
	use 'zbirenbaum/copilot.lua'
	use 'stevearc/dressing.nvim' -- for enhanced input UI
	use 'folke/snacks.nvim' -- for modern input UI

	-- Avante.nvim with build process
	use {
		'yetone/avante.nvim',
		branch = 'main',
		run = 'make',
		--config = function()
		--	require("avante").setup({
		--		-- Input UI (fine as-is)
		--		input = {
		--			provider = "snacks",
		--			provider_opts = {
		--				title = "Avante Input",
		--				icon = " ",
		--				placeholder = "Enter your API key...",
		--			},
		--		},

		--		-- ✅ Explicit default provider
		--		provider = "openai",

		--		-- ✅ Explicit provider table
		--		providers = {
		--			-- 🚫 Disable Claude entirely
		--			claude = {
		--				enabled = false,
		--			},

		--			-- ✅ Enable OpenAI explicitly
		--			openai = {
		--				enabled = true,
		--				endpoint = "https://api.openai.com/v1",
		--				model = "gpt-4o",
		--				timeout = 30000,
		--				extra_request_body = {
		--					temperature = 0,
		--					max_tokens = 4096,
		--				},
		--			},
		--		},
		--	})
		--end
	}
end)
