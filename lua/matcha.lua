--- *matcha.nvim* Match and toggle augroups and options
--- *Matcha*
---
--- MIT License Copyright (c) mvllow
---
--- ==============================================================================
---
--- Features:
---
--- - Quickly toggle vim options and augroups
--- - Lovely defaults, no configuration required
--- - Integrates with [mini.clue](https://github.com/echasnovski/mini.clue) and [which-key.nvim](https://github.com/folke/which-key.nvim)
--- # Setup ~
---
--- Install via your preferred package manager:
--- >lua
---   {
---     source = "mvllow/matcha.nvim",
---     config = function()
---       require("matcha").setup()
---     end
---   }
--- <

local Matcha = {}
local State = {}

---@class Config
---@field prefix string
---@field keys table<string, string>
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
Matcha.config = {
	prefix = [[\]],
	keys = {
		["-"] = "matcha_supplement",
		a = "matcha_copilot",
		b = "background",
		c = "cmdheight",
		d = "matcha_diagnostics",
		f = "FormatOnSave",
		g = "matcha_diff_overlay",
		h = "matcha_inlay_hints",
		l = "list",
		m = "laststatus",
		n = "number",
		q = "matcha_quickfix",
		s = "spell",
		t = "matcha_tmux_status",
		w = "wrap",
		z = "foldcolumn"
	},
	default_option_values = {
		cmdheight = 1,
		laststatus = 2
	}
}
--minidoc_afterlines_end

---@param config? Config
---
---@usage >lua
---   require("matcha").setup({
---   	prefix = [[\]],
---   	keys = {
---   		r = "relativenumber"
---   	}
---   })
--- <
function Matcha.setup(config)
	Matcha.config = vim.tbl_deep_extend("force", Matcha.config, config or {})

	State.matcha_snapshot = {}

	for key, value in pairs(Matcha.config.keys) do
		vim.keymap.set("n", Matcha.config.prefix .. key, function()
			Matcha.toggle(value)
		end, { desc = "Toggle " .. value })
	end
end

--- Toggle augroups, options or matcha builtins
---
---@param name string
Matcha.toggle = function(name)
	-- Toggle builtin
	if name:find("^matcha_") ~= nil then
		local ok, builtin = pcall(require, "matcha." .. name)
		if ok then
			builtin.toggle()
		else
			vim.notify("No builtin with name '" .. name .. "'", vim.log.levels.INFO, { title = "matcha.nvim" })
		end
		return
	end

	-- Toggle option
	local is_option, option = pcall(function() return vim.opt[name] end)
	if is_option then
		local option_value = option:get()

		if type(option_value) == "boolean" then
			vim.opt_local[name] = not vim.opt_local[name]:get()
		elseif type(option_value) == "number" then
			if option_value > 0 then
				State.matcha_snapshot[name] = option_value
				vim.opt[name] = 0
			else
				vim.opt[name] = State.matcha_snapshot[name] or
					Matcha.config.default_option_values[name] or 0
			end
		else
			if name == "background" then
				vim.o.bg = vim.o.bg == "light" and "dark" or "light"
			end

			if name == "foldcolumn" then
				vim.o.foldcolumn = vim.o.foldcolumn == "0" and "1" or "0"
			end

			if name == "signcolumn" then
				-- Account for "auto" and "yes:2" etc.
				vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"
			end
		end

		vim.notify("Set " .. name .. " to " .. tostring(vim.opt_local[name]:get()))
		return
	end

	-- Toggle augroup
	local has_commands, commands = pcall(vim.api.nvim_get_autocmds, { group = name })
	if has_commands and type(commands) == "table" then
		State.matcha_snapshot[name] = commands
		pcall(vim.api.nvim_del_augroup_by_name, name)
		vim.notify(name .. " disabled", vim.log.levels.INFO, { title = "matcha.nvim" })
	else
		commands = State.matcha_snapshot[name] or commands

		vim.api.nvim_create_augroup(name, { clear = true })

		if type(commands) == "table" then
			vim.print("here")
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
				vim.notify(name .. " enabled", vim.log.levels.INFO, { title = "matcha.nvim" })
			end
		end
	end
end

--- Add matcha prefix to mini.clue
--- https://github.com/echasnovski/mini.clue
---@private
Matcha.clues_trigger = function()
	return { mode = "n", keys = Matcha.config.prefix }
end

vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Add matcha prefix to mini.clue triggers",
	group = vim.api.nvim_create_augroup("MatchaSetup", { clear = true }),
	callback = function()
		vim.b.miniclue_config = {
			triggers = {
				require("matcha").clues_trigger(),
			},
		}
	end,
})

return Matcha
