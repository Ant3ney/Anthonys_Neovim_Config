vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

vim.cmd [[
  hi! link Macro PreProc
  hi! link UPROPERTY Macro
  hi! link UFUNCTION Macro
  hi! link UCLASS Macro
  hi! link GENERATED_BODY Macro
]]

vim.opt.clipboard = "unnamedplus"

require("Unreal_Engine")
print("Welcome to Unreal Engine Config")
