# matcha.nvim

> Match and toggle augroups

## Install

Use your favourite package manager. No setup required.

```lua
{
	"mvllow/matcha.nvim"
}
```

## Usage

```lua
-- Create or use an existing augroup with autocommands
local lsp_formatting = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_clear_autocmds({ group = lsp_formatting })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_formatting,
	callback = function()
		vim.lsp.buf.format()
	end,
})

vim.keymap.set("n", [[\f]], function()
	require("matcha").toggle("LspFormatting")
end)
```
