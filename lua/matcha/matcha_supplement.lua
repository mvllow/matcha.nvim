local M = {}

M.toggle = function()
	local ok, supplement = pcall(require, "supplement")
	if not ok then
		vim.notify("Unable to find dependency `supplement.nvim`", vim.log.levels.ERROR, { title = "matcha.nvim" })
		return
	end

	local status, error = pcall(supplement.toggle)
	if not status then
		vim.notify("Unable to toggle supplement: " .. error, vim.log.levels.ERROR, { title = "matcha.nvim" })
	end
end

return M
