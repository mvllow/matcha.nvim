local M = {}

M.toggle_copilot = function()
	if vim.b.copilot_enabled then
		vim.notify("copilot disabled", vim.log.levels.INFO, { title = "matcha.nvim" })
		vim.cmd("Copilot disable")
	else
		vim.notify("copilot enabled", vim.log.levels.INFO, { title = "matcha.nvim" })
		vim.cmd("Copilot enable")
	end
end

M.toggle_diagnostics = function()
	if vim.diagnostic.is_disabled() then
		vim.notify("diagnostics enabled", vim.log.levels.INFO, { title = "matcha.nvim" })
		vim.diagnostic.enable()
	else
		vim.notify("diagnostics disabled", vim.log.levels.INFO, { title = "matcha.nvim" })
		vim.diagnostic.disable()
	end
end

M.toggle_diff_overlay = function()
	local has, mini_diff = pcall(require, "mini.diff")
	if has then
		mini_diff.toggle_overlay()
	end
end

M.toggle_quickfix = function()
	local is_open = false
	for _, window in pairs(vim.fn.getwininfo()) do
		if window["quickfix"] == 1 then
			is_open = true
		end
	end
	if is_open then
		vim.notify("quickfix closed", vim.log.levels.INFO, { title = "matcha.nvim" })
		vim.cmd("cclose")
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.notify("quickfix opened", vim.log.levels.INFO, { title = "matcha.nvim" })
		vim.cmd("copen")
	else
		vim.notify("quickfix is empty", vim.log.levels.INFO, { title = "matcha.nvim" })
	end
end

local builtins = {
	matcha_copilot = M.toggle_copilot,
	matcha_diagnostics = M.toggle_diagnostics,
	matcha_diff_overlay = M.toggle_diff_overlay,
	matcha_quickfix = M.toggle_quickfix,
}

M.toggle_builtin = function(name)
	if builtins[name] ~= nil then
		builtins[name]()
	else
		vim.notify("No builtin with name '" .. name .. "'", vim.log.levels.INFO, { title = "matcha.nvim" })
	end
end

return M
