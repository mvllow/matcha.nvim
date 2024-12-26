local M = {}

M.toggle = function()
	local has_gitsigns, gitsigns = pcall(require, "gitsigns")
	if has_gitsigns then
		pcall(gitsigns.preview_hunk_inline)
		return
	end

	local has_mini_diff, mini_diff = pcall(require, "mini.diff")
	if has_mini_diff then
		pcall(mini_diff.toggle_overlay)
		return
	end

	vim.notify("Unable to toggle diff overlay: " .. error, vim.log.levels.ERROR, { title = "matcha.nvim" })
end

return M
