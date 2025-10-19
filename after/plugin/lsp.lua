

if not vim.g.training_mode then
	vim.lsp.enable('clangd')
	vim.lsp.enable('ts')
	print("Train mode disabled")
else
	disable_all_lsps()
	print("Train mode enabled")
end


vim.api.nvim_create_user_command("Train", function()
	if not vim.g.training_mode then
		vim.g.training_mode = true
		disable_all_lsps()
		print("Train mode enabled")

	else
		vim.g.training_mode = false
		vim.lsp.enable('clangd')
		vim.lsp.enable('ts')
		print("Train mode disabled")
	end
end, {})


function disable_all_lsps()
	for _, c in pairs(vim.lsp.get_clients({ name = "ts" })) do c:stop(true) end
	for _, c in pairs(vim.lsp.get_clients({ name = "clangd" })) do c:stop(true) end
end

print("Enabled clangd LSP")
