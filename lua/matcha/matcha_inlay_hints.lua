local M = {}

M.toggle = function()
	if vim.lsp.inlay_hint.is_enabled() then
		vim.lsp.inlay_hint.enable(false)
		vim.notify("Inlay hints disabled", vim.log.levels.INFO, { title = "matcha.nvim" })
	else
		vim.lsp.inlay_hint.enable()
		vim.notify("Inlay hints enabled", vim.log.levels.INFO, { title = "matcha.nvim" })
	end
end

return M
