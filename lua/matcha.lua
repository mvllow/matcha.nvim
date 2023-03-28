local toggle_option = require("matcha.vim-options").toggle_option
local toggle_augroup = require("matcha.vim-augroups").toggle_augroup

local M = {}

M.toggle = function(name)
	-- If name is all lowercase treat as vim option
	-- else treat as vim augroup
	if name == name:lower() then
		toggle_option(name)
	else
		toggle_augroup(name)
	end
end

return M
