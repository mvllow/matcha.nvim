local M = {}

M.toggle = function()
	if vim.diagnostic.is_enabled() then
		vim.diagnostic.enable(false)
		vim.notify("Diagnostics disabled", vim.log.levels.INFO, { title = "matcha.nvim" })
	else
		vim.diagnostic.enable()
		vim.notify("Diagnostics enabled", vim.log.levels.INFO, { title = "matcha.nvim" })
	end
end

return M
