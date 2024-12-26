local M = {}

M.toggle = function()
	local is_open = false
	for _, window in pairs(vim.fn.getwininfo()) do
		if window["quickfix"] == 1 then
			is_open = true
		end
	end
	if is_open then
		vim.cmd("cclose")
		vim.notify("Quickfix closed", vim.log.levels.INFO, { title = "matcha.nvim" })
		return
	end
	if vim.tbl_isempty(vim.fn.getqflist()) then
		vim.notify("Quickfix is empty", vim.log.levels.INFO, { title = "matcha.nvim" })
	else
		vim.cmd("copen")
		vim.notify("Quickfix opened", vim.log.levels.INFO, { title = "matcha.nvim" })
	end
end

return M
