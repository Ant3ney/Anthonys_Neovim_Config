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

-- Override handler to filter unwanted clangd errors
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
  if not result.diagnostics then return end

  -- Define suppress list: substrings to match against clangd messages
  local suppress_patterns = {
	  "Suppress nothing"
  }

  -- Filter diagnostics
  local filtered = {}
  for _, diagnostic in ipairs(result.diagnostics) do
    local keep = true
    for _, pat in ipairs(suppress_patterns) do
      if diagnostic.message:match(pat) then
        keep = false
        break
      end
    end
    if keep then
      table.insert(filtered, diagnostic)
    end
  end

  result.diagnostics = filtered
  vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end


vim.diagnostic.config({signs=true, underline=true, severity_sort=true})

print("Configed clangd lsp")
