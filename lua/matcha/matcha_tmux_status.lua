local M = {}

M.initial_state = nil

function M.toggle()
	local status = vim.trim(vim.fn.system("tmux show -w status"))

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to run tmux", vim.log.levels.ERROR, { title = "matcha.nvim" })
		return
	end

	-- TODO: Should we revert to the initial state
	-- on VimLeave?
	if M.initial_state == nil then
		M.initial_state = vim.split(status, " ")[2]
	end

	local current_status = vim.split(status, " ")[2]
	local new_status = current_status == "on" and "off" or "on"

	local success = vim.fn.system("tmux set -w status " .. new_status)

	if vim.v.shell_error == 0 then
		vim.notify("Tmux status " .. new_status, vim.log.levels.INFO, { title = "matcha.nvim" })
	else
		vim.notify("Failed to set tmux status", vim.log.levels.ERROR, { title = "matcha.nvim" })
	end
end

return M
