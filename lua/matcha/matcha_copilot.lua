local M = {}

M.toggle = function()
	if not vim.fn.exists(":Copilot") == 2 then
		vim.notify("Unable to find command `:Copilot`", vim.log.levels.ERROR, { title = "matcha.nvim" })
		return
	end

	local enabled = false
	if vim.b.copilot_enabled ~= nil then
		enabled = vim.b.copilot_enabled
	else
		enabled = vim.cmd("Copilot status"):find("Ready")
	end
	if enabled then
		vim.b.copilot_enabled = false
		vim.notify("Copilot disabled", vim.log.levels.INFO, { title = "matcha.nvim" })
	else
		vim.b.copilot_enabled = true
		vim.notify("Copilot enabled", vim.log.levels.INFO, { title = "matcha.nvim" })
	end
end

return M
