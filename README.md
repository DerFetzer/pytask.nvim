# pytask.nvim

A super simple plugin that allows to list and run [Poe](https://github.com/nat-n/poethepoet) tasks inside a [Poetry](https://python-poetry.org/) environment.

## Installation

Install the plugin with your preferred package manager:

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'derfetzer/pytask.nvim'

lua << EOF
require("nvim-autopairs").setup {}
EOF
```

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
use {
	"derfetzer/pytask.nvim",
    config = function() require("pytask").setup()  end
}
```

## Usage

At the moment this plugin provides a single command `:PytaskPoe` that shows a selection for running existing `poe` tasks.
The picked task is run inside a regular terminal or uses [toggleterm](https://github.com/akinsho/toggleterm.nvim) if it is installed.
