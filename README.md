# SpellBound.nvim :sparkles:

Spelling commands and mappings for Neovim.

## Features

- Automatically turn on spelling for certain file types
- Add mapping and command for toggling spelling on/off
- Add mappings for fixing spelling relative to the cursor

## Installation and Requirements

Requires Neovim 0.7+

Ensure a dictionary is set in your `init.lua` file:

```lua
vim.o.dictionary = '/usr/share/dict/cracklib-small'
```

The easiest way to get the above file within your filesystem is to download the [Cracktime-Runtime](https://ubuntu.pkgs.org/20.04/ubuntu-main-arm64/cracklib-runtime_2.9.6-3.2_arm64.deb.html) package.

With [Packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
require('packer').startup(function(use)
  use 'superDross/spellbound.nvim'
end)
```

## Commands

- `:SpellingToggle` -- toggle spelling on/off

## Configuration & Mappings

- `mapping.toggle_map` -- mapping for toggling spelling on/off (default: `Ctrl-S`)
- `mapping.fix_right` -- fix the nearest spelling mistake to the right of the cursor with the first suggestion (default: `Ctrl-l`)
- `mapping.fix_left` -- fix the nearest spelling mistake to the left of the cursor with the first suggestion (default: `Ctrl-h`)
- `language` -- language to check spelling against
- `autospell_filetypes` -- filetypes that should have spelling activated when opened
- `autospell_gitfiles` -- activate spelling for git commit and rebase buffers
- `number_suggestions` -- number of suggestions to display with `z=`

### Defaults

```lua
-- default settings
vim.g.spellbound_settings = {
  mappings = {
    toggle_map = '<C-s>'
    fix_right  = '<C-l>',
    fix_left   = '<C-h>',
  },
  language     = 'en_gb',
  autospell_filetypes = { '*.txt', '*.md', '*.rst' },
  autospell_gitfiles = true,
  number_suggestions = 10,
}
```

### Custom Configuration

To change the language to Spanish and toggle map key, but keep the fix maps defaults, then add the following to your `init.lua`:

```lua
vim.g.spellbound_settings = {
  mappings = {
    toggle_map = '<Leader>s'
  },
  language     = 'es',
}
```
