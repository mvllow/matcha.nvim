local M = {}
local snapshot = {}

M.toggle = function(name)
	local has_commands, commands = pcall(vim.api.nvim_get_autocmds, { group = name })

	if has_commands and type(commands) == "table" then
		snapshot[name] = commands
		M.disable(name)
	else
		M.enable(name, commands)
	end
end

M.enable = function(name, commands)
	commands = snapshot[name] or commands

	vim.api.nvim_create_augroup(name, { clear = true })

	for _, command in pairs(commands) do
		local opts = {}
		opts.desc = command.desc or ""
		opts.group = command.group_name or name

		-- Use one of pattern or buffer
		if command.pattern ~= nil then
			opts.pattern = command.pattern
		elseif command.buffer ~= nil then
			opts.buffer = command.buffer
		end

		-- Use one of callback or command
		if command.callback ~= nil then
			opts.callback = command.callback
		elseif command.command ~= nil then
			opts.command = command.command
		end

		vim.api.nvim_create_autocmd(command.event, opts)
	end

	vim.notify(name .. " enabled", vim.log.levels.INFO, { title = "matcha.nvim" })
end

M.disable = function(name)
	pcall(vim.api.nvim_del_augroup_by_name, name)
	vim.notify(name .. " disabled", vim.log.levels.INFO, { title = "matcha.nvim" })
end

return M
