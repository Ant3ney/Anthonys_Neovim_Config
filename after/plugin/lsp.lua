
local ok, cmp = pcall(require, 'cmp')
if ok then
  -- global switch
  vim.g.cmp_enabled = true

  cmp.setup({
    -- make cmp obey the toggle
    enabled = function() return vim.g.cmp_enabled end,
    -- keep the rest of your cmp config here (snippet, mapping, sources, ...)
  })

  -- <leader>fj: toggle completion UI
  vim.keymap.set('n', '<leader>fj', function()
    vim.g.cmp_enabled = not vim.g.cmp_enabled
    if not vim.g.cmp_enabled then cmp.abort() end
    print('nvim-cmp: ' .. (vim.g.cmp_enabled and 'ON' or 'OFF'))
  end, { desc = 'Toggle completion popup (nvim-cmp)' })
end

vim.lsp.enable('clangd')
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

vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { focus = true, scope = "cursor" })
end, { desc = "Show diagnostic in floating window" })

vim.keymap.set('n', 'gd', function()
	vim.lsp.buf.definition()
end)

vim.diagnostic.config({signs=true, underline=true, severity_sort=true})

vim.keymap.set("n", "<leader>fd", function()
  diagnostics_virtual_text = not diagnostics_virtual_text
  vim.diagnostic.config({ virtual_text = diagnostics_virtual_text })
  print("Diagnostics virtual_text = " .. tostring(diagnostics_virtual_text))
end, { desc = "Toggle diagnostics virtual_text" })

vim.g.unrealnvim_debug = true
print("Enabled clangd LSP")
