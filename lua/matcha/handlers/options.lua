local M = {}
local snapshot = {}

local default_number_values = {
	cmdheight = 1,
	laststatus = 2,
}

local toggle_number_option = function(option)
	local current_value = vim.opt[option]:get()
	if current_value > 0 then
		snapshot[option] = current_value
		vim.opt[option] = 0
	else
		vim.opt[option] = snapshot[option] or default_number_values[option] or 0
	end
	vim.notify(option .. " set to " .. vim.opt.laststatus:get(), vim.log.levels.INFO, { title = "matcha.nvim" })
end

local non_boolean_options = {
	background = function()
		vim.o.bg = vim.o.bg == "light" and "dark" or "light"
		vim.notify("background set to " .. vim.o.bg, vim.log.levels.INFO, { title = "matcha.nvim" })
	end,
	signcolumn = function()
		vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"
		vim.notify("signcolumn set to " .. vim.o.signcolumn, vim.log.levels.INFO, { title = "matcha.nvim" })
	end,
}

M.toggle_option = function(option)
	if vim.opt[option] == nil then
		vim.notify("unable to find " .. option, vim.log.levels.WARN, { title = "matcha.nvim" })
		return
	end

	if non_boolean_options[option] ~= nil then
		non_boolean_options[option]()
	elseif type(vim.opt[option]:get()) == "number" then
		toggle_number_option(option)
	elseif type(vim.opt[option]:get()) == "boolean" then
		vim.cmd("set " .. option .. "!")
		vim.notify(
			option .. (vim.opt[option]:get() and " enabled " or " disabled"),
			vim.log.levels.INFO,
			{ title = "matcha.nvim" }
		)
	end
end

return M
