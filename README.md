# tidalnvim

[Tidal][tidal] integration for [Neovim][neovim]

## Note

Please note that this plugin is still in active development. It should be
stable enough by now for everyday use. If you encounter any bugs, or have ideas
for new features, please report them on the [issue
tracker](https://github.com/john-d-murphy/tidalnvim/issues), thanks!

## Installation

### Requirements

* [Neovim][neovim] >= 0.4.3
* [Tidal][tidal]

### Procedure

#### 1. Install the vim plugin

* Do this using your favorite plugin manager. I prefer Tim Pope's [pathogen][pathogen].

#### 2. Starting TidalNvim

Open a new file in `nvim` with a `.tidal` extension and type `:TidalNvimStart` to start Tidal.

## Mappings

| Map     | Description                                       | Name                                  | Mode           |
| ---     | ---                                               | ---                                   | ---            |
| `<C-e>` | Send current block or line (depending on context) | `<Plug>(tidalnvim-send-block)`        | Insert, Normal |
| `<C-e>` | Send current selection                            | `<Plug>(tidalnvim-send-selection)`    | Visual         |
| `<M-e>` | Send current line                                 | `<Plug>(tidalnvim-send-line)`         | Insert, Normal |
| `<CR>`  | Toggle post window buffer                         | `<Plug>(tidalnvim-postwindow-toggle)` | Insert, Normal |
| `<M-L>` | Clear post window buffer                          | `<Plug>(tidalnvim-postwindow-clear)`  | Insert, Normal |

To remap any of the default mappings use the `nmap` command together with the name of the mapping.

E.g. `nmap <F5> <Plug>(tidalnvim-send-block)`

To disable all default mappings specify `let g:tidalnvim_no_mappings = 1` in your vimrc/init.vim

## Commands

| Command          | Description |
| ---------------- | ----------- |
| `TidalNvimStart` | Start Tidal |
| `TidalNvimStop`  | Stop Tidal  |

## Configuration

The following variables are used to configure tidalnvim. This plugin should work
out-of-the-box so it is not necessary to set them if you are happy with the
defaults.

Run `:checkhealth` to diagnose common problems with your config.

### Post window

```vim
" vertical 'v' or horizontal 'h' split
let g:tidalnvim_postwin_orientation = 'v'

" position of the post window 'right' or 'left'
let g:tidalnvim_postwin_direction = 'right'

" default is half the terminal size for vertical and a third for horizontal
let g:tidalnvim_postwin_size = 25

" automatically open post window on a Tidal error
let g:tidalnvim_postwin_auto_toggle = 1
```

### Eval flash

```vim
" duration of the highlight
let g:tidalnvim_eval_flash_duration = 100

" number of flashes. A value of 0 disables this feature.
let g:tidalnvim_eval_flash_repeats = 2

" configure the color
highlight TidalNvimEval guifg=black guibg=white ctermfg=black ctermbg=white
```

### Extras

```vim
" set this variable if you don't want any default mappings
let g:tidalnvim_no_mappings = 1

```

## Example configuration

```vim
" ==================== TidalNvim =====================
" remap send block
autocmd FileType tidal nmap <buffer> <leader>rw <Plug>(tidalnvim-send-block)

let g:tidalnvim_configuration_file = "/home/murphy/tidalcycles_start/BootTidal.hs"
```

## Gigantic thanks to these plugins for being shoulders to stand on

[scnvim](https://github.com/supercollider/scvim)

[vim-tidal](https://github.com/tidalcycles/vim-tidal)

## License

```plain
tidalnvim - Tidal integration for Neovim
Copyright © 2020 John Murphy

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```

[neovim]: https://github.com/neovim/neovim
[tidal]: https://tidalcycles.org/index.php/Welcome
[pathogen]: https://github.com/tpope/vim-pathogen
