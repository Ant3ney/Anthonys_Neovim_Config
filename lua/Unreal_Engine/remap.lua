vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local cmp = require("cmp")

cmp.setup({
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
  })
})

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

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { })
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

print("Remaped Keys For Unreal Engine Config")
