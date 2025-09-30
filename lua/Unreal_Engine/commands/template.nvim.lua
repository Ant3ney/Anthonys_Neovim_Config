local project_name = [[_____@@@PROJECT_NAME@@@_____]] 
vim.notify("Hello World from this project's " .. project_name .. " .nvim.lua!", vim.log.levels.INFO)

-- Define a project-local keymap
vim.keymap.set("n", "<leader>h", function()
  print("Hello from this project!")
end, { desc = "Say Hello World" })

vim.keymap.set("n", "<C-b>", function()
  -- Open a new horizontal split terminal
  vim.cmd("split term://cmd.exe")

  -- Send commands into the terminal
  vim.fn.chansend(vim.b.terminal_job_id, {
    "cd Scripts\r",
    "general_build_command.bat\r",
  })
end, { desc = "Build editor project (run Scripts/BuildEditorProject.bat)" })

-- ./project/.nvim.lua
-- Hotkey: <leader>vb runs UnrealBuildTool to generate clang database

vim.keymap.set("n", "<leader>vb", function()
  -- Open a new horizontal split terminal running cmd.exe
  vim.cmd("split term://cmd.exe")

  -- Send the command into the terminal
  vim.fn.chansend(vim.b.terminal_job_id, { 
    "cd Scripts\r",
    "compile_commands_build_command.bat\r",
 })
end, { desc = "Run UBT GenerateClangDatabase and move file" })

