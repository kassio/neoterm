# neoterm

Use the same terminal for everything. The main reason for this plugin is reuse
the terminal easily. All commands opens a terminal if it's not open or reuse the
open terminal.
REPL commands, opens a terminal and the proper REPL, if it's not opened.

- NeoVim terminal helper functions/commands.
- Wraps some REPL to receive current line or selection.
- Many terminals support:
  - ![many-terms](https://cloud.githubusercontent.com/assets/120483/8921869/fe459572-34b1-11e5-93c9-c3b6f3b44719.gif)

## Installation

To install this plugin, you should use one of the following methods.
For Windows users, replace usage of the Unix `~/.vim` directory with
`%USERPROFILE%\_vim`, or another directory if you have configured
Vim differently. On Windows, your `~/.vimrc` file will be similarly
stored in `%USERPROFILE%\_vimrc`.

### i. Installation with Vundle/Plug.vim/minpac/any other

You can install this plugin using any vim plugin manager by using the path on
GitHub for this repository:

```vim
[Plugin|Plug|...] 'kassio/neoterm'
```

See the your plugin manager documentation for more information.

### ii. Manual Installation

For installation without a package manager, you can clone this git repository
into a bundle directory as with pathogen, and add the repository to your
runtime path yourself. First clone the repository.

```console
cd ~/.vim/bundle
git clone https://github.com/kassio/neoterm.git
```

Then, modify your `~/.vimrc` file to add this plugin to your runtime path.

```vim
set nocompatible
filetype off

let &runtimepath.=',~/.vim/bundle/neoterm'

filetype plugin on
```

You can add the following line to generate documentation tags automatically,
if you don't have something similar already, so you can use the `:help` command
to consult neoterm's online documentation:

```vim
silent! helptags ALL
```

Because the author of this plugin is a weird nerd, this is his preferred
installation method.

## test libs (removed on 05/Feb/2017)

*This feature was removed on 05/Feb/2017, please consider to use the
vim-test with `neoterm` strategy to replace this feature*

- [Related issue](https://github.com/kassio/neoterm/issues/123).

## REPL

* `TREPLSend`: sends the current line or the selection to a REPL in a terminal.
* `TREPLSendFile`: sends the current file to a REPL in a terminal.
* `<Plug>(neoterm-repl-send)`: sends with text-objects or motions, or sends the
  selection to a REPL in a terminal.
* `<Plug>(neoterm-repl-send-line)`: sends the current line to a REPL in a
  terminal.

### REPLs supported

* Ruby: `pry` and `irb`
* Rails: `bundle exec rails console`
* Python: `ipython` and `python`
* JavaScript: `node`
* Elixir: `iex`
* Julia: `julia`
* R / R Markdown: `R`
* Haskell: `ghci`
* Idris: `idris`
* GNU Octave: `octave`
  * For Octave 4.0.0 and later, you can enable Qt widgets (dialogs, plots, etc.) using `g:neoterm_repl_octave_qt = 1`
* MATLAB: `matlab -nodesktop -nosplash`
* PARI/GP: `gp`
* PHP: `psysh` and `php`

### Troubleshooting

Most standard file extensions for the above REPLs are picked up by Neovim's default
filetype plugins. However, there are two exceptions:
* Julia `.jl` files, which are detected as `filetipe=lisp`
* Idris `.idr`, `.lidr` files which are not recognised as any filetype
To fix this, either install a suitable plugin for the language or add something like
the following to your `init.vim`:
```viml
au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
au VimEnter,BufRead,BufNewFile *.idr set filetype=idris
au VimEnter,BufRead,BufNewFile *.lidr set filetype=lidris
```

## other useful commands:

* `:T <command>`: Opens a terminal, or use an opened terminal, and runs the
                  given command within a terminal.
* `:Tmap <command>`: maps a the given command to `,tt`.

## Contributing

Open a pull request, repls and other features to this plugin. :smiley:

## Changelog

* 03/03/2018
  - **DEPRECATE g:neoterm_split_on_tnew** - `:Tnew` now accepts vim mods (`:help mods`).
  - Introduce `g:neoterm_tnew_mod` to set a default `:Tnew` mod (`:help mods`).
  - Revamp `:Topen`. Now `:[mods][N]Topen` accepts vim mods (`:h mods`) and a
    target, so if one wants to open the neoterm with id 2 in vertical, one can
    do `:vert 2Topen`.
  - Revamp `:Tclose`. Now `:[N]Tclose[!]` accepts a target, so one can close any
    neoterm by its id.
