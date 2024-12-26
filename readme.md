# matcha.nvim

> Match and toggle augroups and options

## Features

- Quickly toggle vim options and augroups
- Lovely defaults, no configuration required
- Integrates with [mini.clue](https://github.com/echasnovski/mini.clue) and [which-key.nvim](https://github.com/folke/which-key.nvim)

## Setup

Install via your preferred package manager:

```lua
{
  source = "mvllow/matcha.nvim",
  config = function()
    require("matcha").setup()
  end
}
```

## Usage

Setting `keys` inside the setup function will configure keymaps with a shared prefix and relevant description. Your prefix is automatically added as a [mini.clue](https://github.com/echasnovski/mini.clue) trigger.

```lua
-- Default configuration
require("matcha").setup({
	prefix = [[\]],
	keys = {
		f = "FormatOnSave",
		b = "background",
		n = "number",
		d = "matcha_diagnostics",
	}
})
```

Alternatively, we can use the toggle method directly:

```lua
require("matcha").toggle("FormatOnSave")
```

### Augroups

Reference existing augroups in our matcha keys or directly via `matcha.toggle`. If the name is not a valid vim option it will be treated as an augroup.

<details>

<summary>Example setup of format on save augroup</summary>

<br />

```lua
local formatting = vim.api.nvim_create_augroup("FormatOnSave", {})
vim.api.nvim_clear_autocmds({ group = formatting })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = formatting,
	callback = function()
		vim.lsp.buf.format()
	end,
})

-- Assign a key in the matcha setup
require("matcha").setup({
	keys = {
		f = "FormatOnSave"
	},
})

-- Or toggle directly
require("matcha").toggle("FormatOnSave")
```

</details>

### Vim options

Use matcha to toggle vim options. All boolean values should be supported, as well as a few special cases mentioned below.

`background` - Toggle between "light" and "dark"

`cmdheight` - Toggle between 0 and initial value or 1

`foldcolumn` - Toggle between 1 and initial value or 0

`laststatus` - Toggle between 0 and initial value or 2

`signcolumn` - Toggle between "yes" and "no"

### Matcha options

In addition to vim options, matcha includes builtins for toggling more complex types. See [how they're implemented](/lua/matcha/handlers/builtins.lua).

`matcha_copilot` - Enable/disable `copilot.vim`

`matcha_diagnostics` - Enable/disable `vim.diagnostic`

`matcha_diff_overlay` - Enable/disable `mini.diff` overlay

`matcha_inlay_hints` - Enable/disable inlay hints

`matcha_quickfix` - Open/close quickfix menu

`matcha_tmux_status` - Show/hide tmux status

## Contributing

Contributions are welcome and appreciated 💜
