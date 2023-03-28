local default_config = require("matcha.config")
local toggle_option = require("matcha.vim-options").toggle_option
local toggle_augroup = require("matcha.vim-augroups").toggle_augroup

local M = {}
M.config = {}

M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", {}, default_config, opts or {})

	for k, v in pairs(M.config.keys) do
		vim.keymap.set("n", M.config.prefix .. k, function()
			M.toggle(v)
		end, { desc = "Toggle " .. v })
	end
end

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
