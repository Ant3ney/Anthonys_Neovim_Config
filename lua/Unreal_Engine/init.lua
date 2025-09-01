-- Completion popup behavior
vim.o.completeopt = 'menu,menuone,noselect'

-- nvim-cmp (popup + Tab confirm)
local cmp = require('cmp')
cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    -- move selection (no arrows)
    ['<C-j>']     = cmp.mapping.select_next_item(),
    ['<C-k>']     = cmp.mapping.select_prev_item(),
    -- optional: classic terminal keys
    ['<C-n>']     = cmp.mapping.select_next_item(),
    ['<C-p>']     = cmp.mapping.select_prev_item(),
    -- confirm
    ['<Tab>']     = cmp.mapping.confirm({ select = true }), -- Tab accepts current item
  }),
  sources = { { name = 'nvim_lsp' }, { name = 'luasnip' } },
})


local caps = vim.lsp.protocol.make_client_capabilities()
caps.offsetEncoding = { "utf-8", "utf-16" }   -- or { "utf-16" }
caps.textDocument.completion = caps.textDocument.completion or {}
caps.textDocument.completion.snippetSupport = true
caps.textDocument.completion.editsNearCursor = true

-- 2) Augment with nvim-cmp’s defaults (keeps what you set above)
caps = require('cmp_nvim_lsp').default_capabilities(caps)

vim.lsp.config('clangd', {
  cmd = {
    [[C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\x64\bin\clangd.exe]],
    '--background-index',
    '--clang-tidy',
    '--header-insertion=never',
    '--completion-style=detailed',
    '--all-scopes-completion',
    '--compile-commands-dir=C:/Users/antho/Desktop/AnthonysFolder/Games/pvh_landing/div/03/PVH',
    '--log=verbose',
    -- MSVC/clang-cl discovery so system includes are resolved:
    '--query-driver=C:/Program Files/Microsoft Visual Studio/2022/*/VC/Tools/MSVC/*/bin/**/cl.exe;C:/Program Files/Microsoft Visual Studio/2022/*/VC/Tools/Llvm/bin/clang-cl.exe;C:/Program Files/LLVM/bin/clang-cl.exe',
    "--background-index",         -- build & persist project-wide index
  "--pch-storage=disk",         -- cache preambles on disk across sessions

    -- Use this ONLY if your DB is not at the project root:
    -- '--compile-commands-dir=C:/Users/antho/Desktop/AnthonysFolder/Games/pvh_landing/div/03/PVH',
  },
  filetypes = { 'c','cpp','objc','objcpp','h','hpp','hxx','hh','cc','cxx' },
  root_markers = { 'compile_commands.json', '*.uproject', '.git', '.clangd' },
  capabilities = caps,
})

require("Unreal_Engine.remap")

print("Configed clangd lsp")
print("Finished Configuring Unreal Engine Module")
