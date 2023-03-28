# matcha.nvim

> Match and toggle augroups and options

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

-- Toggle augroups
vim.keymap.set("n", [[\f]], function()
	require("matcha").toggle("LspFormatting")
end)

-- Toggle options
vim.keymap.set("n", [[\b]], function()
	require("matcha").toggle("background")
end)
vim.keymap.set("n", [[\n]], function()
	require("matcha").toggle("number")
end)
```

## Argument types

If a name passed to matcha is lowercase we treat it as a vim option, otherwise
consider it a vim augroup.

All boolean vim options should be supported. There are special handlers for
non-boolean options. Contributions are welcome and appreciated, especially if
supporting more options.
