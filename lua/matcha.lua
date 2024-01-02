local default_config = require("matcha.config")
local toggle_augroup = require("matcha.handlers.augroups").toggle_augroup
local toggle_builtin = require("matcha.handlers.builtins").toggle_builtin
local toggle_option = require("matcha.handlers.options").toggle_option

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
	if name:find("^matcha_") ~= nil then
		toggle_builtin(name)
	elseif name == name:lower() then
		toggle_option(name)
	else
		toggle_augroup(name)
	end
end

--- Add matcha prefix to mini.clue
--- https://github.com/echasnovski/mini.clue
--- @usage
--- ```lua
--- require("mini.clue").setup({
--- 	triggers = {
--- 		require("matcha").clues_trigger()
--- 	}
--- })
--- ```
M.clues_trigger = function()
	return { mode = "n", keys= M.config.prefix or default.config.prefix }
end

--- Add matcha prefix to mini.clue
vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Add matcha prefix to mini.clue triggers",
	callback = function()
		vim.b.miniclue_config = {
			triggers = {
				require("matcha").clues_trigger()
			}
		}
	end
})

return M
