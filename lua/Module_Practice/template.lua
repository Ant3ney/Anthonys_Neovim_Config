
vim.keymap.set("n", "<C-i>", function()
	vim.cmd("split | terminal")
	vim.fn.chansend(vim.b.terminal_job_id, {
		"cd Scripts\r",
		"build_project_command.bat\r"
	})
end, {})

vim.keymap.set("n", "<leader>i", function()
	vim.cmd("split | terminal")
	vim.fn.chansend(vim.b.terminal_job_id, {
		"cd Scripts\r",
		"build_clangd_database_command.bat\r"
	})
end, {})



