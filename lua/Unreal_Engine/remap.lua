vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { focus = true, scope = "cursor" })
end, { desc = "Show diagnostic in floating window" })

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

vim.keymap.set('n', 'gd', function()
	vim.lsp.buf.definition()
end)

vim.keymap.set("n", "<leader>fd", function()
  diagnostics_virtual_text = not diagnostics_virtual_text
  vim.diagnostic.config({ virtual_text = diagnostics_virtual_text })
  print("Diagnostics virtual_text = " .. tostring(diagnostics_virtual_text))
end, { desc = "Toggle diagnostics virtual_text" })

print("Remaped Keys For Unreal Engine Config")
