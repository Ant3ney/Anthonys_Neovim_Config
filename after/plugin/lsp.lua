
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
	  "No matching member function for call to 'CreateDefaultSubobject'",
	  "Base class '.*' has private copy constructor",
	  "Cannot initialize return object of type 'UObject %*'",
	  "with an expression of type 'UDeathEffect'",
	  "Cannot initialize object parameter of type 'IEnhancedInputSubsystemInterface' with an expression of type 'UEnhancedInputLocalPlayerSubsystem'",
	  "No viable conversion from 'struct FLogCategoryLogTemp' to 'const FLogCategoryBase'",
	  "Use of undeclared identifier 'GetController'; did you mean 'AController'",
	  "Use of undeclared identifier 'Super'",
	  "Static assertion failed due to requirement 'TIsArrayOrRefOfTypeByPredicate<const wchar_t",
	  "No member named 'GetCompileTimeVerbosity' in 'FLogCategoryLogTemp'",
	  "No member named 'IsSuppressed' in 'FLogCategoryLogTemp'",
	  "Cannot initialize object parameter of type 'IEnhancedInputSubsystemInterface' with an expression of type 'UEnhancedInputLocalPlayerSubsystem'",
	  "Use of undeclared identifier 'FindComponentByClass'",
	  "Incomplete type 'ULocalPlayer' named in nested name specifier",
	  "Out-of-line definition of '%*_Implementation' does not match any declaration in",
	  "Use of undeclared identifier 'HasAuthority'",
	  "No member named 'GetComponentByClass' in"
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
