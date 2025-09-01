-- Completion popup behavior
vim.o.completeopt = 'menu,menuone,noselect'

-- nvim-cmp (popup + Tab confirm)
local cmp = require('cmp')
cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  sources = { { name = 'nvim_lsp' }, { name = 'luasnip' } },
})

require("Unreal_Engine.lsp")

require("Unreal_Engine.remap")

print("Finished Configuring Unreal Engine Module")
