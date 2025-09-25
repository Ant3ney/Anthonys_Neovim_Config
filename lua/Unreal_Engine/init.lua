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

-- Automatically load project-local configs from root or configs/
vim.opt.exrc = true
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local cwd = vim.fn.getcwd()

    -- First check project root
    local root_cfg = cwd .. "/.nvim.lua"

    -- Then check subfolder (configs/.nvim.lua)
    local sub_cfg = cwd .. "/DevSpace/Anthony/.nvim.lua"

    -- Try loading whichever exists, in order
    if vim.fn.filereadable(root_cfg) == 1 then
      local ok, err = pcall(dofile, root_cfg)
      if not ok then
        vim.notify("Error loading root .nvim.lua: " .. err, vim.log.levels.ERROR)
      end
    elseif vim.fn.filereadable(sub_cfg) == 1 then
      local ok, err = pcall(dofile, sub_cfg)
      if not ok then
        vim.notify("Error loading configs/.nvim.lua: " .. err, vim.log.levels.ERROR)
      end
    end
  end,
})

require("Unreal_Engine.commands")

print("Finished Configuring Unreal Engine Module")
