local M = {}
local health = require("vim.health")

local function check_dependencies()
	health.start("Optional dependencies")
	if vim.fn.exists(":Copilot") == 2 then
		health.ok("`:Copilot` command found.")
	else
		health.warn("`:Copliot` command not found.", {
			"Install [copilot.vim](https://github.com/github/copilot.vim)"
		})
	end

	if pcall(require, "mini.diff") then
		health.ok("`mini.diff` package found.")
	else
		health.warn("`mini.diff` package not found.", {
			"Install [mini.diff](https://github.com/echasnovski/mini.diff)"
		})
	end

	if pcall(require, "supplement") then
		health.ok("`supplement.nvim` package found.")
	else
		health.warn("`supplement.nvim` package not found.", {
			"Install [supplement.nvim](https://github.com/mvllow/supplement.nvim)"
		})
	end
end

function M.check()
	check_dependencies()
end

return M
